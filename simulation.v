module tb;

reg clk;
reg rst;

wire [6:0] seg;
wire [3:0] an;
wire dp;

top dut(
    .clk(clk),
    .rst(rst),
    .seg(seg),
    .an(an),
    .dp(dp)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    #8000;
    $finish;
end

initial
begin
    $dumpfile("clock.vcd");
    $dumpvars(0,tb);
end

initial
begin
    $monitor($time ,"  sec=%0d  min=%0d  hr=%0d",
        dut.seconds,
        dut.minutes,
        dut.hours
    );
end

endmodule
