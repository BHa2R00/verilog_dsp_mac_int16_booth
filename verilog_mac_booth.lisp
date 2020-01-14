(defparameter *dw* 16)
(format t
"module mac~A
(//y=ax+b
	input wire [~A:0]	a,x,b,
	output wire [~A:0]	y
);
wire	sig_a=a[~A];
wire	sig_x=x[~A];
wire	sig_b=b[~A];
wire	sig_ax=sig_a^sig_x;
wire [~A:0]	a0={1'b0,a[~A:0]};
wire [~A:0]	x0={1'b0,x[~A:0]};
wire [~A:0]	p0={~A'h00,x0,1'b0};
//booth------------------------------
"
	*dw*
	(1- *dw*)
	(1- *dw*)
	(1- *dw*)
	(1- *dw*)
	(1- *dw*)
	(1- *dw*) (- *dw* 2)
	(1- *dw*) (- *dw* 2)
	(* *dw* 2) *dw*
	)
(do ((n 1 (+ n 1))
     (m 0 (+ m 1)))
  ((> n *dw*))
  (format t
"wire [1:0]	p~A_c=p~A[1:0];
wire [32:0]	p~A_00={1'b0,p~A[32:1]};
wire [32:0]	p~A_01={1'b0,(p~A[32:17]+a0),p~A[16:1]};
wire [32:0]	p~A_10={1'b0,(p~A[32:17]-a0),p~A[16:1]};
wire [32:0]	p~A=((p~A_c==2'b00)||(p~A_c==2'b11))?p~A_00:((p~A_c==2'b01)?p~A_01:((p~A_c==2'b10)?p~A_10:p~A));
"
	  n m
	  n m
	  n m m
	  n m m
	  n n n n n n n n m))
(format t 
"//-----------------------------------
wire [~A:0]	ax={sig_ax,p~A[~A:1]};
assign	y=ax+b;
endmodule
"
	(1- *dw*) *dw* (1- *dw*))
