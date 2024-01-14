module LED(
    input               clk     ,
    input               rst_n   ,
    //input      [7:0]    led_cmd ,
    output reg     ld         
);

    reg [25:0]	cnt; //时钟寄存器

//计时器模块
always@(negedge rst_n or posedge clk)begin
	if(!rst_n)begin
		cnt <= 26'd0;//初始化计时器为0
		ld <= 1'b1;//初始化led灯，高电平有效
	end
	else if(cnt == 26'd50_000_000-1)begin
		cnt <= 26'd0;
		ld <= ~ld;//1s钟led取反
	end 
	else begin
		cnt <= cnt + 26'd1;
		ld <= ld;//其他时刻，led等于其自身
	end
end

    // assign en = 1'b1;
    // always @(en)begin
        // if (en == 1'b1) begin
    //   led <= 4'b1111;
    // end else begin
    //   led <= 4'b0000;
    // end
// end

    // parameter TIME_1500MS = 75_000_000;

    // reg     [26:0]      cnt     ;
    // wire                add_cnt ;
    // wire                end_cnt ;

    // reg     [2:0]       cnt1    ;
    // wire                add_cnt1;
    // wire                end_cnt1;

    // always @(posedge clk or negedge rst_n)begin
        // if(!rst_n)begin
            // cnt <= 27'b0;
        // end
        // else if(add_cnt)begin
            // if(end_cnt)begin
                // cnt <= 27'b0;
            // end
            // else begin
                // cnt <= cnt + 1'b1;
            // end
        // end
        // else begin
            // cnt <= cnt;
        // end
    // end

    // assign add_cnt = 1'b1;
    // assign end_cnt = add_cnt && cnt == TIME_1500MS - 1;

    // always @(posedge clk or negedge rst_n)begin 
        // if(!rst_n)begin
            // cnt1 <= 2'b0;
        // end
        // else if(add_cnt1)begin
            // if(end_cnt1)begin
                // cnt1 <= 2'b0;
            // end
            // else begin
                // cnt1 <= cnt1 + 1'b1;
            // end
        // end
        // else begin 
            // cnt1 <= cnt1;
        // end
    // end

    // assign add_cnt1 = end_cnt;
    // assign end_cnt1 = add_cnt1 && cnt1 == 7;

    // always @(*)begin
        // if(!rst_n)begin
            // led = 4'b1111;
        // end
        // else begin
            // case(cnt1)
                // 3'b000 : led = 4'b0001;
                // 3'b001 : led = 4'b0011;
                // 3'b010 : led = 4'b0111;
                // 3'b011 : led = 4'b1111;
                // 3'b100 : led = 4'b1110;
                // 3'b101 : led = 4'b1100;
                // 3'b110 : led = 4'b1000;
                // 3'b111 : led = 4'b0000;
                // default : led = 4'b1111;
            // endcase
        // end
    // end


endmodule
