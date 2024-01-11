module	min(qs, qm, qh, qs0,qs1,qm1,qm0,qh0,alarm,qh1,clk,rst,ah0,ah1,am0,am1);
	input	clk,rst;
	input	[3:0]ah0,ah1,am0,am1;
	output 	reg alarm; 
	output 	reg [3:0] qs0,qs1,qm1,qm0,qh0,qh1;
	output	[7:0]qs,qm,qh;

	initial qh0<=4'b0000;
	initial qh1<=4'b0000;
	initial qm0<=4'b0000;
	initial qm1<=4'b0000;
	initial qs0<=4'b0000;
	initial qs1<=4'b0000;

	assign	qs={qs1,qs0};
	assign	qm={qm1,qm0};
	assign	qh={qh1,qh0};

	always@(posedge clk or posedge rst)
	begin
	if(rst==1)
		begin
		qh0<=4'b0000;
		qh1<=4'b0000;
		qm0<=4'b0000;
		qm1<=4'b0000;
		qs0<=4'b0000;
		qs1<=4'b0000;
		end

	else
	begin
	if(qs0==4'b1001)
	begin
		qs0<=4'b0000;
		qs1<=qs1+1;
	end
		
		if(qs1==4'b0101 && qs0==4'b1001)
		begin
			qs1<=4'b0000;
			qs0<=4'b0000;
			qm0<=qm0+1;
		end

		
			if(qm0==4'b1001 && qs1==4'b0101 && qs0==4'b1001)
			begin
				qm0<=4'b0000;
				qm1<=qm1+1;
			end

				if(qm1==4'b0101 && qm0==4'b1001 && qs1==4'b0101 && qs0==4'b1001)
				begin
					qm1<=4'b0000;
					qm0<=4'b0000;
					qh0<=qh0+1;
				end
				

					if(qh0==4'b1001 && qm1==4'b0101 && qm0==4'b1001 && qs1==4'b0101 && qs0==4'b1001)
					begin
						qh1<=4'b0000;
						qh0<=4'b0000;
						qh1<=qh1+1;
					end
					
						
						if(qh1==4'b0010 && qh0==4'b0100 && qm1==4'b0101 && qm0==4'b1001 && qs1==4'b0101 && qs0==4'b1001)
						begin
							qh0<=4'b0000;
							qh1<=4'b0000;
							qm0<=4'b0000;
							qm1<=4'b0000;
							qs0<=4'b0000;
							qs1<=4'b0000;
						end
						
						else begin
							qs0=qs0+1;
						end
					end
	end


	always@(*)
	begin
		if({ah0,ah1,am0,am1}=={qh0,qh1,qm0,am1}) begin
			alarm=1'b1;
		end
		else begin
			alarm=1'b0;
		end
	end

endmodule

module min_tb();

reg	clk, rst;
reg	[3:0] ah0, ah1, am0, am1;

wire	alarm;
wire	[3:0] qs0, qs1, qm1, qm0, qh0, qh1;
wire	[7:0]qs, qm, qh;
min	dut(qs, qm, qh, qs0,qs1,qm1,qm0,qh0,alarm,qh1,clk,rst,ah0,ah1,am0,am1);

initial begin
    clk = 0;
    rst = 0;
    ah0 = 4'b0000;
    ah1 = 4'b0000;
    am0 = 4'b0110;
    am1 = 4'b0011;

    #5 rst = 1;
    #20 rst = 0;

    #1000 $finish;
end

always #1 clk = ~clk;

endmodule
