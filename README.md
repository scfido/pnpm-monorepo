# 简介

使用father、dumi、pnpm技术栈的React组件单一仓库模板。

# 使用

## 安装依赖

在根目录执行会自动安装所有项目的依赖包。

```pwsh
pnpm install
```

清理所有依赖

```pwsh
pnpm clean
```

清理所有依赖并重新安装

```pwsh
pnpm reinstall
```

## 启动文档项目

文档项目有两个作用：
1. 介绍组件的使用方法
2. 组件的功能演示

```pwsh
pnpm start
```

# 开发


## 创建新包

在这个模板中新添加一个包，操作流程如下，以创建`liba`为例：

```pwsh
cd .\packages\
mkdir liba
cd liba
pnpm dlx create-father ./ 

# 根据提示选择或输入你的信息。
# √ Pick target platform(s) » Browser
# √ Pick NPM client » pnpm
# √ Input NPM package name ... liba
# √ Input NPM package description ...
# √ Input NPM package author (Name <email@example.com>) ...
```

包目录创建好后，添加react组件之前要对项目参数做一些简单的配置。

在`.\packages\liba\tsconfig.json`，的`compilerOptions`中增加`jsx`、`esModuleInterop`、`sourceMap`三项参数。

```json
{
  "compilerOptions": {
    "strict": true,
    "declaration": true,
    "skipLibCheck": true,
    "baseUrl": "./",
    "jsx": "react",
    "esModuleInterop": true,
    "sourceMap": true
  }
}
```

然后添加你要开发的组件依赖包

```pwsh
# 添加依赖包react
pnpm add react
```

添加组件文件`.\packages\liba\src\Button.tsx`

```jsx
// .\packages\liba\src\Button.tsx

import React from "react";

export default ()=>{
    return(<button>From lib a</button>)
}
```

导出组件

```ts
// .\packages\liba\src\index.ts

export {default as ButtonA}  from "./Button"
```

生成

```pwsh
cd .\packages\liba
pnpm build
```

生成成功后会在`.\packages\liba\dist\esm`中看到结果。

## 在文档中展示组件

前面已经创建好了包`liba`，并创建了组件`ButtonA`，下面在文档中展示这个组件。

在`.\packages\docs`包中，添加`liba`的应用。

```json
 // .\packages\docs\package.json

 "dependencies": {
    // 添加liba的依赖，注意版本号的写法。
    "liba": "workspace:^1.0.0"
    // ... 其它依赖
 }
```

在创建`.\packages\docs\src\libA`的目录，并新建展示文档`index.md`。

    # .\packages\docs\src\libA\index.md
    ---
    nav:
      title: Components
      path: /components
    ---

    ## Libiary A

    Button A:

    ```tsx
    import React from 'react';
    import {ButtonA} from "liba";

    export default () => {
      return(
        <div>
        <ButtonA/>
        </div>
      )
    };

    ```

启动文档项目就能看到liba中的组件展示了。

```pwsh
pnpm start
```

### 热更新

组件展示文档项目运行起来后，文档自身的修改是能够热更新的，但是引用的liba包中的组件并不能热更新，修改了组件内容后，需要在组件目录运行`pnpm build`才能生效。要实现组件的热更新，可以在组件包目录中使用`pnpm dev`来监视文件变更并自动`build`。

```pwsh
cd .\packages\liba
pnpm dev
```

# 发布

发布分为发布说明文档和组件两种情况。

## 发布文档

将文档发布成网站。

```pwsh
pnpm docs:build --filter docs
```

输出目录在`packages\docs\docs-dist`，这些文件放在web服务中就可以访问。例如使用dotnet-serve工具。

```pwsh
# 安装dotnet-serve
dotnet tool install --global dotnet-serve

# 启动网站
cd c
dotnet serve -o
```

## 发布组件

发布组件非常简单，和npm的操作流程一致。在根目录下执行`pnpm publish`即可。通过[npmjs.org](https://npmjs.org)用户注册等一系列操作发布成功。完成后发现并不是我们要的结果，这样是把整个项目作为单个包发布出去了。而我们想要的是发布这三个包。

- @pnpm-monorepo/liba
- @pnpm-monorepo/libb
- @pnpm-monorepo/libc

其实也非常简单，使用`filter`参数过滤项目，或者分别到各自的目录下去发布就可以了。

```pwsh
# 使用指定项目名称的方式
pnpm publish --filter liba
pnpm publish --filter libb
pnpm publish --filter libc

# 使用通配符过滤的方式，注意windows下不要单引号。
pnpm publish --filter 'lib*'

# 进入到项目目录下发布的方式
cd  .\packages\liba
pnpm publish

cd ..\libb
pnpm publish

cd ..\libc
pnpm publish
```

## 统一包版本

如果希望发布的所有包版本统一，可使用以下命令。脚本会自动把`packages`目录下的项目设置为指定版本号，并且会自动添加添加git tag。

```pwsh
./set-version.ps1 1.1.4
```

# 引用包

包开发完成后就是给其它项目使用了，按上面的步骤发布到`npm`仓库后，按常规操作用名称引用即可。

但是在开发过程中要引用本地包怎么操作呢？分仓库内和仓库外两种引用情况。

## 仓库内

在同一仓库内引用，比如`docs`项目引用`liba`。只需要在`docs`项目中执行添加包命令，并加上`-w``--workspace`参数，表面是引用workspace中的包。
```pwsh
# 中项目根目录操作需要带过滤条件
pnpm add liba -w --filter docs

# 进入包的目录可以直接添加
cd .\packages\docs
pnpm add liba -w
```

## 仓库外

开发时其它仓库需要引用本项目的包时，可使用pnpm的`link`命令。

1. 在被引用的仓库执行
  ```pwsh
  # 例如liba是要被引用的库，将liba注册到全局仓库
  cd .\packages\liba
  pnpm link . --global
  ```
2. 在引用的仓库执行
  ```pwsh
  # 从全局仓库连接 liba
  pnpm link liba --global
  ```
  注意：连接后会在`package.json`的`dependencies`中添加`liba`。如果你的包从来没有发布过，以后执行install的时候会因为找不到这个包而失败。

# 常见问题

## ANTD组件没有加载CSS

在docs项目中引用ANTD组件，并在文档中增加样式引用。

```tsx
import React from 'react';
import {Button} from "libb";
import 'antd/dist/antd.css';

export default () => {
  return(
    <div>
    <Button/>
    </div>
  )
};

```

## 包修改以后不生效

我发现包减少输出文件引用包的node_modules下仍然存在的情况，建议全部删除后重新安装。

```powershell
pnpm reinstall
```

## 报找不到引用包的文件

`docs`项目生成报找不到引用包的文件，并且错误信息中的文件位置在`docs/src`目录下，这是因为引用包编译失败，`没有输出到docs的node_modules`中，因为docs在`tsconfig.josn`中重定义了`@/*:["src/*"]`，所以不要被编译错误中的文件位置误导了。