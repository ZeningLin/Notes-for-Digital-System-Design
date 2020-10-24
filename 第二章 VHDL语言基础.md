# 第二章 VHDL语言基础

## 2.3 VHDL程序主要构件
- Library 库
- Package 包
- Entity 实体
- Architecture 结构体
- Configuration 配置
### 2.3.1 库
- IEEE库
  - `std_logic_1164`: *functions & data types for multi-level logic*
  - `std_logic_arith`: *defines signed, unsigned types and basic arithmetic operations for representing integers in standard ways*
  - `std_logic_signed`: *signed arithmetic functions*
  - `std_logic_unsigned`: *overloading operators for mixed operation, coversion between different data types*
  
  - for datatype `std_logic` and `std_logic_vector`, **only logical operations can be applied without packages `std_logic_signed` and `std_logic_unsigned`**

- STD库
  - 默认库，定义最基本的数据类型，调用时**不需要显式说明**
- WORK库
  - 存放用户定义的单元和包，调用时**不需要显式说明**

### 2.3.2 实体

```VHDL
ENTITY entitiy_name IS
    GENERIC(const_name:dtype:=value); --[类属参数说明],分号结尾
    PORT(port_name:port_direction dtype); --[端口说明],分号结尾
END [ENTITY] entity_name; --分号结尾
```

- `entity_name` 不能以数字开头
- `[类属参数说明]` 是**常数**，用于说明时间参数、总线宽度等静态信息
- `-[端口说明]` 的`dtype`有四种，分别为：
  - IN
  - OUT
  - INOUT
  - BUFFER: 内部有**反馈** 
- `-[端口说明]`格式如下 
````VHDL
PORT(port1_name:port1_direction dtype; --每个声明之间用分号分隔
    port2_name:port2_direction dtype; --每个声明之间用分号分隔
    port3_name:port3_direction dtype); --最后一个声明不需要分号分隔，但外部括号有分号
````

### 2.3.3 结构体

```VHDL
ARCHITECTURE architecture_name OF entity_name IS
  [DEFINITION]  --定义语句，可定义signal,constant,type,function,component等
BEGIN
  [concurrent statements]
END architecture_name
```

- `architecture_name` 不能以数字开头
- `DEFINITON` **only valid in its defining architecture**
- Each design entity composes only one entity and one architecture. Therefore, it is necessary to specify which of the architectures should be used at any particular time through `configuration declaration`

### 2.3.4 配置
```VHDL
CONFIGURATION configuration_name OF entity_name IS
  FOR architecture_name
  END FOR;
END configuration_name;
```
- `architecture_name` 指多个结构体中要选用的结构体名称


----
## 2.4 VHDL数据对象

### 2.4.1 常量
````VHDL
CONSTANT const_name:dtype:=value --注意要有CONSTANT做引导
````

### 2.4.2 变量
```
VARIABLE variable_name:dtype:=value
```
- Defined in `process` or sub-program (`function`, `procedure`)
- It is **Local** but not Global
- Valid only in the **sequential** areas within a process, sub-program (not within the architecture body)

### 2.4.3 信号

#### 信号的定义
   ```VHDL
   SIGNAL signal_name:dtype:=value  --使用:=对信号赋初值
                                          --这个初始值只用于仿真，综合器不支持
   ```
- 信号在声明时用`:= `赋初值
- 信号赋值使用 `<=` 注意此操作有**延时**
  - 对于在进程内的信号赋值操作，每次进程`process`被触发后，虽然进程内有赋值语句，但是**只有当这次进程结束时信号的赋值语句才会生效**
- **All `PORTS` of an `ENTITY` are signals by default**

#### 信号与变量的比较
- `SIGNAL`是global量，可在多个`PROCESS`中传递，但是`VARIABLE`是local量，仅在当前的进程、子程序中有效
- `SIGNAL`除了值以外还存放了历史信息、波形值等，可用于仿真，但是`VARIABLE`不可以仿真
- `PROCESS`只对信号敏感，不对变量敏感