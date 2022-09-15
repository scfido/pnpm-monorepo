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


## 添加包

在这个模板中新添加一个包，操作流程如下，已创建`liba`为例：

```pwsh
cd .\packages\
mkdir liba
cd liba
npx create-father ./ 

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
    "liba": "workspace:"
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
cd packages\docs\docs-dist
dotnet serve -o
```

## 发布组件

