module clk_divider(
    output reg clkout,
    input clk,
    input rst
    );

reg [25:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        count<=0;
        clkout<=0;
    end
    else
    begin
    if(count==4)
    begin
        clkout<=~clkout;
        count<=0;
    end
    else
       count<=count+1;
    end

end
endmodule

module seconds(
    output reg [5:0] sec,
    output reg sec_flag,
    input clk,
    input rst
    );

 always @(posedge clk or posedge rst)
 begin
    if(rst)
    begin
        sec<=6'b0;
        sec_flag<=0;
    end
    else
    begin
    if(sec==59)
    begin
        sec<=6'b0;
        sec_flag<=1;
    end
    else
    begin
       sec<=sec+1;
       sec_flag<=0;
    end
 end
 end
endmodule

module minutes(
    output reg [5:0] mins,
    output reg min_flag,
    input rst,
    input clk,
    input sec_flag
);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        mins<=6'b0;
        min_flag<=0;
    end
    else
    begin
        if(sec_flag)
        begin
            if(mins==59)
            begin
                mins<=6'b0;
                min_flag<=1;
            end
            else
            begin
                mins<=mins+1;
                min_flag<=0;
            end
        end
        else
        begin
            min_flag<=0;
        end
    end
end
endmodule

module hours(
    output reg [4:0] hr,
    input clk,
    input rst,
    input min_flag
    );

always @(posedge clk or posedge rst)
begin
    if(rst)
    hr<=5'b0;
    else
    begin
        if(min_flag)
        begin
            if(hr==23)
            hr<=5'b0;
            else
            hr<=hr+1;
        end
        
    end
end
endmodule


module ssd_mmss(
     input clk,
     input rst,
     input [5:0] minutes,
     input [5:0] seconds,
     output reg [6:0] seg,
     output reg [3:0] an,
     output reg dp
);
wire [3:0] sec_ones,sec_tens;
wire [3:0] min_ones,min_tens;

assign min_tens=minutes/10;
assign min_ones=minutes%10;

assign sec_tens=seconds/10;
assign sec_ones=seconds%10;

reg [15:0] refresh_counter;

always @(posedge clk or posedge rst)
begin
    if(rst)
    refresh_counter<=0;
    else
    refresh_counter<=refresh_counter+1;
end
wire [1:0] digit_select;
assign digit_select=refresh_counter[15:14];

reg [3:0] current_digit;

always @(*)
begin
    case(digit_select)
    2'b00:current_digit=sec_ones;
    2'b01:current_digit=sec_tens;
    2'b10:current_digit=min_ones;
    2'b11:current_digit=min_tens;
    default:current_digit=4'd0;
    endcase
end

always @(*)
begin
    case(digit_select)
    2'b00:an=4'b1110;
    2'b01:an=4'b1101;
    2'b10:an=4'b1011;
    2'b11:an=4'b0111;
    default:an=4'b1111;
    endcase
end

always @(*)
begin
    case(current_digit)
        4'd0: seg = 7'b1000000;
        4'd1: seg = 7'b1111001;
        4'd2: seg = 7'b0100100;
        4'd3: seg = 7'b0110000;
        4'd4: seg = 7'b0011001;
        4'd5: seg = 7'b0010010;
        4'd6: seg = 7'b0000010;
        4'd7: seg = 7'b1111000;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0010000;
        default: seg = 7'b1111111;
    endcase
end

always @(*)
begin
    case(digit_select)
    2'b01:dp=0;     // decimal point between MM and SS
    default:dp=1;
    endcase
end
endmodule

module top(
           input rst,input clk,
           output [6:0] seg,
           output [3:0] an,
           output dp
           );

wire clkout;
wire [5:0] seconds, minutes;
wire [4:0] hours;
wire sec_flag,min_flag;

clk_divider cd1(.clk(clk),.clkout(clkout),.rst(rst));
seconds m1(.clk(clkout),.rst(rst),.sec(seconds),.sec_flag(sec_flag));
minutes m2(.clk(clkout),.rst(rst),.mins(minutes),.min_flag(min_flag),.sec_flag(sec_flag));
hours   m3(.clk(clkout),.rst(rst),.hr(hours),.min_flag(min_flag));
ssd_mmss display(.clk(clk),.rst(rst),.minutes(minutes),.seconds(seconds),.seg(seg),.an(an),.dp(dp));

endmodule
