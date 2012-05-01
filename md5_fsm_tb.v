/*-
 * Copyright (c) 2009 Stanislav Sedov <stas@FreeBSD.org>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * md5 fsm test bench.
 */

`timescale 1ns/1ns
`include "defines.h"
`include "md5_fsm.v"

module md5_test();
	reg clk;
	reg rdy;
	reg [0:31] msg;
	wire [0:127] hash_o;
	wire rdy_o;
	wire busy_o;
	reg rst;
	integer j;

	always begin
		#5 clk = ~clk;
	end
	
	initial begin
		clk = 0;
		rdy = 0;
		$display("time\tclk\trdy\trst\tmsg\thash_o\n");

		$dumpvars(1, clk, rdy, rst, msg, hash_o, md5_fsm.core_a,
		    md5_fsm.core_b, md5_fsm.core_c, md5_fsm.core_d, md5_fsm.core_m,
		    md5_fsm.core_s, md5_fsm.core_t, md5_fsm.core_round, md5_fsm.core_out,
		    md5_fsm.round, md5_fsm.state, md5_fsm.newstate);

//		$dumpvars(1, clk, rdy, rst, msg, hash_o);
		$monitor("%g\t%b\t%b\t%b\t%h\t%h\n", $time, clk, rdy, rst, msg, hash_o);
		rst = 1;
		#10 rst = 0;

//0, 19, 41, 48

		for (j = 0; j < 64; j = j + 1) begin
			rdy = 1;
			if (j == 0 || j == 19 || j == 41 || j == 48)
				msg = 1<<31;
			else
				msg = 0;
			#10;
		end
		rdy = 0;

		#40 $finish;
	end

	md5_fsm md5_fsm(clk, rdy, msg, rst, hash_o);
endmodule
