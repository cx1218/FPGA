module top(
    input           clk     ,
    input           rst_n   ,
    inout           dq      ,
    input           rx      ,//从pc端发来的控制指令
    input           key     ,//从端口导入进来的需要消抖的按键
    output          tx      ,
    output          pwm     ,
    output  [5:0]   sel     ,
    output  [7:0]   dig     ,
    output  reg[3:0]    LED
);
    parameter TIME_1500MS = 75_000_000;
    reg     [26:0]      cnt     ;
    wire                add_cnt ;
    wire                end_cnt ;
    wire                    en          ;
    wire                    key_out     ;
    wire    [15:0]          t_data      ;
    wire    [23:0]          dis_data    ;
    wire    [7:0 ]          t_data_uart ;
    wire    [7:0]             en_LED    ;
    reg     [7:0]           dec_output  ;//通过串口要发送到pc电脑端的
    wire      [7:0]        dout;
    wire                   dout_vld;

    assign  t_data_uart =  end_cnt ? {1'b0,t_data[10:4]}: t_data_uart ; //按键有效就转换成给uart

    //assign  dout = 8'h31 ? 8'b00000001 : dout ;

    ds18b20_driver      inst_ds18b20_driver(
        .clk                (clk        ),
        .rst_n              (rst_n      ),
        .dq                 (dq         ),
        .t_data             (t_data     ) 
    );

    ctrl                inst_ctrl(
        .t_data             (t_data     ),
        .dis_data           (dis_data   ),
        .en                 (en         ) //处理好的数据   
    );

    sel_driver          inst_sel_driver(
        .clk                (clk        ) ,
        .rst_n              (rst_n      ) ,
        .dis_data           (dis_data   ) ,
        .sel                (sel        ) ,
        .dig                (dig        )  
    );

    // FSM_KEY             inst_FSM_KEY(
        // .clk                (clk        ),
        // .rst_n              (rst_n      ),
        // .key_in             (key        ),
        // .key_out            (key_out    )
    // );

    uart_tx             inst_uart_tx(
        .clk                (clk        ),
        .rst_n              (rst_n      ),
        .din                (t_data_uart),
        .din_vld            (end_cnt    ),
        .dout               (tx         )
    );//没有消抖的时候0有效，消抖之后是1有效

    beep                inst_beep(
        .clk                 (clk  ), 
        .rst_n               (rst_n),
        .en                  (en   ), 
        .key                 (key  ),
        .pwm                 (pwm  )
    );

    uart_rx             inst_uart_rx(
        .clk                 (  clk     ),
        .rst_n               (  rst_n   ),
        .din                 (  rx     ),
        .dout                (  dout    ),//处理好的值
        .dout_vld            (  dout_vld)
    );

    // LED                 inst_LED(
        // .clk                 (  clk     ),
        // .rst_n               (  rst_n   ),
        //.led_cmd             ( en_LED   ),
        // .ld                 (  ld     )
    // );



always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 27'b0;
    end
    else if(add_cnt)begin
        if(end_cnt)begin
            cnt <= 27'b0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
    else begin
        cnt <= cnt;
    end
end
assign add_cnt = 1'b1;
assign end_cnt = add_cnt && cnt == TIME_1500MS - 1;



// always @(posedge clk or negedge rst_n) begin
    // if(rx != 8'b00000000)begin
        // LED = 4'b0101;
    // end
    // else if(rx ==0 )begin
    // LED = 4'b0101;
    // end
//end


    
//  always @(*) begin
    // 
    // if(end_cnt ==1 )
    // case (t_data_uart)
        // 8'h15: dec_output = 8'd21;
        // 8'h16: dec_output = 8'd22;
        // 8'h17: dec_output = 8'd23;
        // 8'h18: dec_output = 8'd24;
        // 8'h19: dec_output = 8'd25;
        // 8'h1A: dec_output = 8'd26;
        // 8'h1B: dec_output = 8'd27;
        // 8'h1C: dec_output = 8'd28;
        // 8'h1D: dec_output = 8'd29;
        // 8'h1E: dec_output = 8'd30;
        // 8'h1F: dec_output = 8'd31;
        // 8'h20: dec_output = 8'd32;
        // 8'h21: dec_output = 8'd33;
        // 8'h22: dec_output = 8'd34;
        // 8'h23: dec_output = 8'd35;
        //继续添加其他情况...
        // default: dec_output = 8'd7;
    // endcase
//  end


endmodule