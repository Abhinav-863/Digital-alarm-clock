
module tpsclock(h1, h2, h3, h4, h5, h6, clk, rst);
    input wire clk, rst;
    output wire [6:0] h1, h2, h3, h4, h5, h6;
    reg [7:0] sec, min, hr;
    reg [7:0] s, m, h;
    reg a, b, c;

    initial begin 
        sec <= 0;
        min <= 0;
        hr <= 0;
        a <= 0;
        b <= 0;
        c <= 0;
        s <= 0;
        m <= 0;
        h <= 0;
    end

    always @(posedge clk) begin
        if (rst == 1 || c == 1) begin
            c = 0;
            s = 0;
            m = 0;
            h = 0;
            sec = 0;
            hr = 0;
            min = 0;
        end
        bcd_adder1;
        if (a == 1) begin
            a = 0;
            bcd_adder2;
        end
        if (b == 1) begin
            b = 0;
            bcd_adder3;	
        end
    end

    b2d_7seg B0 (sec[3:0], h1);
    b2d_7seg B1 (sec[7:4], h2);
    b2d_7seg B2 (min[3:0], h3);
    b2d_7seg B3 (min[7:4], h4);
    b2d_7seg B4 (hr[3:0], h5);
    b2d_7seg B5 (hr[7:4], h6);

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
            else if (s > 49 && s < 60)
                sec = s + 30;
            else if (s > 59) begin
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
            else if (m > 9 && m < 20 )
                min = m + 6; 
            else if (m > 19 && m < 30)
                min = m + 12;
            else if (m > 29 && m < 40)
                min = m + 18;
            else if (m > 39 && m < 50)
                min = m + 24;
            else if (m > 49 && m < 60)
                min = m + 30;
            else if (m > 59) begin
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
            if (h > 9 && h < 20 )
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

endmodule

module b2d_7seg(X, SSD);
    input wire [3:0] X;
    output reg [6:0] SSD;

    always @(X) begin
        case (X)
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
endmodule
