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
- 不能以数字开头

```VHDL
ENTITY entitiy_name IS
    GENERIC(const_name:dtype:=value); --[类属参数说明],分号结尾
    PORT(port_name:port_direction dtype); --[端口说明],分号结尾
END [ENTITY] entity_name; --分号结尾
```
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