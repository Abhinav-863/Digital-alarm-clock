module clkwalarm(
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    clk, rst, im, ih, alarm, on, led
);
    input clk, rst, im, ih, alarm, on;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output reg led;
    reg [7:0] sec, min, hr, amin, ahr;
    reg [7:0] s, m, h, am, ah;
    reg a, b, c;
    reg divclk;
    reg [25:0] div;

    initial begin
        divclk = 0;
        div = 0;
    end

    always @(posedge clk) begin
        div = div + 1'b1;
        divclk = div[25];
    end

    initial begin 
        sec <= 0;
        min <= 0;
        hr <= 0;
        amin <= 0;
        ahr <= 0;
        ah <= 0;
        am <= 0;
        a <= 0;
        b <= 0;
        c <= 0;
        s <= 0;
        m <= 0;
        h <= 0;
    end

    always @(posedge divclk) begin
        if ((c == 1) || (rst == 1)) begin
            c = 0;
            sec = 0;
            s = 0;
            h = 0;
            m = 0;
            am = 0;
            ah = 0;
            amin = 0;
            ahr = 0;
            min = 0;
            hr = 0;
            b2d_7seg(4'b0000, HEX0);
            b2d_7seg(4'b0000, HEX1);
            b2d_7seg(4'b0000, HEX2);
            b2d_7seg(4'b0000, HEX3);
            b2d_7seg(4'b0000, HEX4);
            b2d_7seg(4'b0000, HEX5);
        end
        else if (rst == 0) begin
            bcd_adder1;
            if (a == 1) begin
                a = 0;
                bcd_adder2;
            end
            if (b == 1)  begin
                b = 0;
                bcd_adder3;    
            end
            if (alarm == 0) begin
                b2d_7seg(sec[3:0], HEX0);
                b2d_7seg(sec[7:4], HEX1);
                b2d_7seg(min[3:0], HEX2);
                b2d_7seg(min[7:4], HEX3);
                b2d_7seg(hr[3:0], HEX4);
                b2d_7seg(hr[7:4], HEX5);
            end
        end
        if (alarm == 1) begin
            if (ih == 0) begin
                bcd_adder4;
            end
            if (im == 0) begin
                bcd_adder5;
            end
            b2d_7seg(4'b0000, HEX0);
            b2d_7seg(4'b0000, HEX1);
            b2d_7seg(amin[3:0], HEX2);
            b2d_7seg(amin[7:4], HEX3);
            b2d_7seg(ahr[3:0], HEX4);
            b2d_7seg(ahr[7:4], HEX5);
        end
        if (on == 1) begin
            if ({ahr, amin} == {hr, min})
                led = 1'b1;
        end
        else if (on == 0)
            led = 1'b0;
    end

    task bcd_adder1;
    begin
        s = s + 1'b1;
        if (s < 10)
            sec = s;
        else if (s > 9 && s < 20)
            sec = s + 6;
        else if (s > 19 && s < 30)
            sec = s + 12;
        else if (s > 29 && s < 40)
            sec = s + 18;
        else if (s > 39 && s < 50)
            sec = s + 24;
        else if (s > 49 && s < 60) begin
            sec = 8'b00000000;
            s = 0;
            a = 1;
        end
    end
    endtask

    task bcd_adder2;
    begin
        m = m + 1'b1;
        if (m < 10)
            min = m;
        else if (m > 9 && m < 20)
            min = m + 6; 
        else if (m > 19 && m < 30)
            min = m + 12;
        else if (m > 29 && m < 40)
            min = m + 18;
        else if (m > 39 && m < 50)
            min = m + 24;
        else if (m > 49 && m < 60) begin
            min = 8'b00000000;
            m = 0;
            b = 1;
        end
    end
    endtask

    task bcd_adder3;
    begin
        h = h + 1'b1;
        if (h < 10)
            hr = h;
        if (h > 9 && h < 20)
            hr = h + 6; 
        else if (h > 19 && h < 24)
            hr = h + 12;
        else if (h > 23) begin
            hr = 8'b00000000;
            h = 0;
            c = 1;
        end
    end
    endtask

    task bcd_adder4;
    begin
        ah = ah + 1'b1;
        if (ah < 10)
            ahr = ah;
        if (ah > 9 && ah < 20)
            ahr = ah + 6; 
        else if (ah > 19 && ah < 24)
            ahr = ah + 12;
        else if (ah > 23) begin
            ahr = 8'b00000000;
            ah = 0;
        end
    end
    endtask

    task bcd_adder5;
    begin
        am = am + 1'b1;
        if (am < 10)
            amin = am;
        else if (am > 9 && am < 20)
            amin = am + 6; 
        else if (am > 19 && am < 30)
            amin = am + 12;
        else if (am > 29 && am < 40)
            amin = am + 18;
        else if (am > 39 && am < 50)
            amin = am + 24;
        else if (am > 49 && am < 60) begin
            amin = 8'b00000000;
            am = 0;
        end
    end
    endtask

    task b2d_7seg;
    input [3:0] X;
    output [6:0] SSD;
    begin
        case(X)
            4'b0000 : SSD = 7'b1000000;
            4'b0001 : SSD = 7'b1111001;
            4'b0010 : SSD = 7'b0100100;
            4'b0011 : SSD = 7'b0110000;
            4'b0100 : SSD = 7'b0011001;
            4'b0101 : SSD = 7'b0010010;
            4'b0110 : SSD = 7'b0000010;
            4'b0111 : SSD = 7'b1111000;
            4'b1000 : SSD = 7'b0000000;
            4'b1001 : SSD = 7'b0010000;
        endcase
    end
    endtask
endmodule
