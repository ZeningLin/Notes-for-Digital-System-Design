# Verilog

## 不同进制数的表示
- `4'b0101`=0101b
- `4'd2`=0010b
- `4'ha`=1010b

第一位数字代表对应二进制数的长度，缺省时默认32，第二位字母代表进制，后面的数字代表该进制下的数，可用下划线将较长的数分开增加可读性，编译时忽略

## 标识符
用于定义模块名，端口名，信号名
- 可以是任意一组字母，数字，下划线，$的组合
- 第一个字符必须是字母或者下划线
- **区分大小写**

## 数据类型
### 寄存器类型
```verilog
reg [31:0] delay_cnt;
reg        key_reg;
```
- 声明时不赋初值，默认为`X`状态，只有在`always`和`initial`语句中才赋初值

### 线网类型
- 不指定数据类型时默认为该类型
- 表示结构中的物理连线
- 需要驱动元件连接才能有实际值，没有连接时默认为`Z`状态
```verilog
wire [width:0] wire_name;
```

### 参数类型
```verilog
parameter para_name = para_val;
```

## 运算符
### 逻辑运算符
|符号|功能|
|--|--|
|~|按位取反|
|&|按位与|
|\||按位或|
|^|按位异或|

- 操作对象位宽不同时，将位宽较少的对象高位补零后再操作

### 移位运算符
注意左移后位宽会发生变化，空余出来的位置补零；右移位宽不变

例：
1. `4'b0101 << 2 = 6'b010100`
2. `4'b0101 >> 2 = 4'b0001`

### 拼接运算符
```verilog
c = {a,b[3:0]} //假设a，b均为8位信号，则c为12位信号
```

## Verilog程序框架
```verilog
module module_name(
    input in_port; //声明输入端口
    output out_port; //声明输出端口
    ); 
    
assign ...; //程序主体实现

endmodule
```

## 程序主体实现的方法
### assign语句
- 用于组合逻辑电路

### always
- 用于组合逻辑或者时序逻辑电路
- 在always内部程序顺序执行，类似于VHDL的`process`语句

### 元件例化
- 与VHDL类似，有两种映射方式
```verilog
/*************原始模块定义*************/
module component_name(
    input in_port;
    output out_port;
);

parameter para_name = para_value;

endmodule;


/**************元件例化**************/
// 例化方法1
component_name #(
    // 参数传递
    .para_name  (map_para_name)
) map_component_name(
    .in_port    (map_in_port);
    .out_port   (map_out_port);
);

// 例化方法2
component_name #(
    .para_name  (map_para_name)
) map_component_name(
    // 严格按照原始模块的信号顺序排列
    map_in_port,
    map_out_port
);

// 没有参数传递时格式如下
component_name map_component_name(
    map_in_port,
    map_out_port
);
```

## 结构语句
### initial语句
- 只执行一次
- 常用于测试基准的编写或者对存储器变量赋初值
- 顺序语句
```verilog
initial begin
    var_1       <= 1'b0;
    var_2       <= 1'b1;
    #20 var_3   <= 1'b0;    // #dly代表延时dlyns，相当于wait for语句
    #10 var_3   <= 1'b1;    // 延时时间在上一个节点的基础上计算
end
```

### always语句
- 相当于process语句，当敏感参数表满足要求时，重复执行其中的内容
- 顺序语句
```verilog
always @(para list) begin

    // 顺序语句

end
```
- 为实现上升沿/下降沿触发可用下列语句
```verilog
always @(posedge var_1 or negedge var_2)
```
- 若敏感参数过多，可将always设置为对所有参数敏感
```verilog
always @(*)
```

## 赋值语句
### 阻塞赋值(Blocking)
```verilog
a = b;
```
- 认为只有一个步骤操作：计算右操作数并更新左操作数
- 所谓阻塞赋值，是指在同一个always语句块中，后面的赋值语句是在前一句赋值语句结束后才开始赋值的

### 非阻塞赋值(Non_Blocking)
```verilog
a <= b;
```
- 只能对寄存器类型的变量操作
- 分两步，在赋值语句开始处先计算右操作数，当always语句结束时再统一赋值给左操作数，相当于VHDL的signal延迟更新

**一般规则：组合逻辑的always块中使用阻塞赋值，时序逻辑的always块中用非阻塞赋值，在同一个always块中不能混用两种赋值，也不允许在多个always块中对同一个变量赋值**

## 条件语句
### if语句
- 判断条件中，若为0,x,z均判断为假，仅1判断为真
- 注意不完整if也会产生锁存器
```verilog
if(condition) begin
    //operations
end
else begin
    //operations
end
```
### case语句
```verilog
case (variable)
    val1:       operation_1;
    val2:       operation_2;
    val3:       operation_3;
    default:    opeartion_4;
endcase
```

- 所有表达式的位宽必须相同

### casez和casex语句
- casez做条件比较时不考虑表达式中的z值
- casex做条件比较时不考虑表达式中的x值
```verilog
casez (variable)
    8'b1100_zzzz: operation_1; //仅考虑高四位是否等于1100，低四位不考虑
    8'b1100_xxzz: operatio_2; // 考虑高6位是否为1100xx，低两位不考虑
endcase
```

```verilog
casex (variable)
    8'b1100_xxzz: operation; //仅考虑高四位是否等于1100，其他均不考虑
endcase
```

## 状态机设计
*看起来像是3进程状态机？*
### 1. 状态空间定义
使用parameter来定义状态，使用reg来保存状态(类似用户定义枚举类型表示状态，用信号保存当前状态和下一个状态)
```verilog
// 状态编码可选用二进制，格雷码或者onehot编码
parameter SLEEP = 2'b00;
parameter STUDY = 2'b01;
parameter EAT   = 2'b10;
parameter ENT   = 2'b11;

// 用寄存器保存状态
// 注意位宽要和上面的编码保持一致
reg [1:0] current_state;
reg [1:0] next_state;
```

### 2. 状态跳转
```verilog
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_state <= /*init_state*/;
    else
        current_state <= next_state;
end
```

### 3. 次态判断
```verilog
always @(current_state or input_signals) begin
    case (current_state)
        state_1: begin
        // operation
        end

        state_2: begin
        // operation
        end

        state_3: begin
        // opeartion
        end

        default: ...;
    endcase
end
```

### 4. 状态动作
```verilog
always @(current_state) begin
    case (current_state)
         state_1: begin
        // operation
        end

        state_2: begin
        // operation
        end

        state_3: begin
        // opeartion
        end

        default: ...;
    endcase
end
```