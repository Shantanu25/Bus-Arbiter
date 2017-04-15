module arb (bmif.mstrR m0,bmif.mstrR m1, bmif.mstrR m2, bmif.mstrR m3, svif.slvR s0,svif.slvR s1, svif.slvR s2, svif.slvR s3, input integer amount, input integer numclk, input integer max );

integer m0_amt, m1_amt, m2_amt, m3_amt, timer0, timer1, timer2, timer3, count_clk, count_clk_d;
integer m0_amt_d, m1_amt_d, m2_amt_d, m3_amt_d, timer0_d, timer1_d, timer2_d, timer3_d;


always@(*) begin
if (m0.rst)
	begin
		m0_amt_d = amount;
		m1_amt_d = amount;	
		m2_amt_d = amount;
		m3_amt_d = amount;
		count_clk_d = 0;
		m0.grant = 0;
		m1.grant = 0;
		m2.grant = 0;
		m3.grant = 0;
		timer0_d = 0;
		timer1_d = 0;
		timer2_d = 0;
		timer3_d = 0;
		s0.sel = 0;
		s1.sel = 0;
		s2.sel = 0;
		s3.sel = 0;
	end
	else
	begin
		count_clk_d = count_clk + 1;
		if (count_clk == numclk)
		begin
			count_clk_d = 0;
			if ((m0_amt + amount) < max)
			begin
				m0_amt_d = m0_amt + amount;
			end	
			else
			begin
				m0_amt_d = max;	
			end
			if ((m1_amt + amount) < max)
			begin
				m1_amt_d = m1_amt + amount;
			end	
			else
			begin
				m1_amt_d = max;	
			end
			if ((m2_amt + amount) < max)
			begin
				m2_amt_d = m2_amt + amount;
			end	
			else
			begin
				m2_amt_d = max;	
			end
			if ((m3_amt + amount) < max)
			begin
				m3_amt_d = m3_amt + amount;
			end	
			else
			begin
				m3_amt_d = max;	
			end
		end 


		if (m1.grant == 1)
		begin
			case (m1.addr)
				32'hFFEF0210: begin
						s0.sel = 1;
						s1.sel = 0;
						s2.sel = 0;
						s3.sel = 0;
						s0.RW = m1.RW;
						s0.addr = m1.addr;
						s0.DataToSlave = m1.DataToSlave;
						m1.DataFromSlave = s0.DataFromSlave;
					   end
				32'hFFEF1210: begin
						s0.sel = 0;
						s1.sel = 1;
						s2.sel = 0;
						s3.sel = 0;
						s1.RW = m1.RW;
						s1.addr = m1.addr;
						s1.DataToSlave = m1.DataToSlave;
						m1.DataFromSlave = s1.DataFromSlave;
					   end
				32'hFFEF2210: begin
						s0.sel = 0;
						s1.sel = 0;
						s2.sel = 1;
						s3.sel = 0;
						s2.RW = m1.RW;
						s2.addr = m1.addr;
						s2.DataToSlave = m1.DataToSlave;
						m1.DataFromSlave = s2.DataFromSlave;
					   end
				32'hFFEF3210: begin
						s0.sel = 0;
						s1.sel = 0;
						s2.sel = 0;
						s3.sel = 1;
						s3.RW = m1.RW;
						s3.addr = m1.addr;
						s3.DataToSlave = m1.DataToSlave;
						m1.DataFromSlave = s3.DataFromSlave;
					   end		
				default : begin
						s0.sel =0;
						s1.sel =0;
						s2.sel =0;
						s3.sel =0;
						end			
			endcase	
		end


	         if ((( m1_amt == 1 ? 1 : m0.req >= m1.req ) && (m2_amt ==1? 1 :m0.req >= m2.req) && (m3_amt ==1? 1:m0.req >= m3.req) && m0.xfr == 1 && (m0_amt ==1?0:1))||timer0 == 59||((m1_amt==1 | m1.req == 0) && (m2_amt==1 | m2.req == 0) && (m3_amt==1 | m3.req == 0) && m0.req != 0)&& timer1 < 59 && timer2 <59 && timer3 <59)
		begin		
			timer0_d = 0;
			timer1_d = timer1+1;
			timer2_d = timer2+1;
			timer3_d = timer3+1;
			m0.grant = 1;
			m1.grant = 0;
			m2.grant = 0;
			m3.grant = 0;
			if ((m0_amt - m0.req)<=0 | (m0_amt - m0.req > max))
				m0_amt_d = 1;
			else
				m0_amt_d = m0_amt - m0.req;
		end
		
		if ((( m0_amt == 1 ? 1 : m1.req >= m0.req ) && (m2_amt ==1 ? 1: m1.req >= m2.req) && (m3_amt ==1? 1:m1.req >= m3.req) && m1.xfr == 1  && (m1_amt==1?0:1))||(timer1 == 59))
		begin
			timer0_d = timer0+1;
			timer1_d = 0;
			timer2_d = timer2+1;
			timer3_d = timer3+1;
			m0.grant = 0;
			m1.grant = 1;
			m2.grant = 0;
			m3.grant = 0;
			if ((m1_amt - m1.req)<=0 | (m1_amt - m1.req > max))
				m1_amt_d = 1;
			else
				m1_amt_d = m1_amt - m1.req;
		end
		
		if ((( m0_amt == 1 ? 1 : m2.req >= m0.req ) && (m1_amt ==1? 1:m2.req >= m1.req) && (m3_amt ==1? 1:m2.req >= m3.req) && m2.xfr == 1 && (m2_amt==1?0:1))||(timer2 == 59))
		begin
			timer0_d = timer0+1;
			timer1_d = timer1+1;
			timer2_d = 0;
			timer3_d = timer3+1;
			m0.grant = 0;
			m1.grant = 0;
			m2.grant = 1;
			m3.grant = 0;	
			if ((m2_amt - m2.req)<=0 | (m2_amt - m2.req > max))
				m2_amt_d = 1;
			else
				m2_amt_d = m2_amt - m2.req;
		end
		if ((( m0_amt == 1 ? 1 : m3.req >= m0.req ) && (m1_amt ==1? 1:m3.req >= m1.req) && (m2_amt ==1? 1:m3.req >= m2.req) && m3.xfr == 1 && (m3_amt==1?0:1))||(timer3 == 59))
		begin
			timer0_d = timer0+1;
			timer1_d = timer1+1;
			timer2_d = timer2+1;
			timer3_d = 0;
			m0.grant = 0;
			m1.grant = 0;
			m2.grant = 0;
			m3.grant = 1;	
			if ((m3_amt - m3.req)<=0 | (m3_amt - m3.req > max))
				m3_amt_d = 1;
			else
				m3_amt_d = m3_amt - m3.req;
		end



		
		if (m0.xfr == 0)
			m0.grant = 0;
		if (m1.xfr == 0)
			m1.grant = 0;
		if (m2.xfr == 0)
			m2.grant = 0;
		if (m3.xfr == 0)
			m3.grant = 0;


		
		if ((m0.grant == 0) && (m1.grant == 0) && (m2.grant == 0) && (m3.grant ==0)) begin
		s0.sel = 0;
		s1.sel = 0;
		s2.sel = 0;
		s3.sel = 0;
		end







///////////// CONNECTIONS /////////////////////////

	if(m0.grant==1) begin
	case(m0.addr)
	32'hFFEF0200: begin
		send_to_s0 (m0.DataToSlave, m0.addr, m0.RW);
		m0.DataFromSlave = s0.DataFromSlave;
		end

	32'hFFEF1200: begin
		send_to_s1 (m0.DataToSlave, m0.addr, m0.RW);
		m0.DataFromSlave = s1.DataFromSlave;
		end
	
	32'hFFEF2200: begin
		send_to_s2 (m0.DataToSlave, m0.addr, m0.RW);
		m0.DataFromSlave = s2.DataFromSlave;
		end
	
	32'hFFEF3200: begin
		send_to_s3 (m0.DataToSlave, m0.addr, m0.RW);
		m0.DataFromSlave = s3.DataFromSlave;
		end	
	default : begin
		s0.sel =0;
		s1.sel =0;
		s2.sel =0;
		s3.sel =0;
		end	
	endcase
	end

	if(m3.grant==1) begin
	case(m3.addr)
	32'hFFEF0230: begin
		send_to_s0 (m3.DataToSlave, m3.addr, m3.RW);
		m3.DataFromSlave = s0.DataFromSlave;
		end

	32'hFFEF1230: begin
		send_to_s1 (m3.DataToSlave, m3.addr, m3.RW);
		m3.DataFromSlave = s1.DataFromSlave;
		end
	
	32'hFFEF2230: begin
		send_to_s2 (m3.DataToSlave, m3.addr, m3.RW);
		m3.DataFromSlave = s2.DataFromSlave;
		end
	
	32'hFFEF3230: begin
		send_to_s3 (m3.DataToSlave, m3.addr, m3.RW);
		m3.DataFromSlave = s3.DataFromSlave;
		end	
	default : begin
		s0.sel =0;
		s1.sel =0;
		s2.sel =0;
		s3.sel =0;
		end	
	endcase
	end

	/*if(m1.grant==1) begin
	case(m1.addr)
	32'hFFEF0210: begin
		send_to_s0 (m1.DataToSlave, m1.addr, m1.RW);
		m1.DataFromSlave = s0.DataFromSlave;
		end

	32'hFFEF1210: begin
		send_to_s1 (m1.DataToSlave, m1.addr, m3.RW);
		m1.DataFromSlave = s1.DataFromSlave;
		end
	
	32'hFFEF2210: begin
		send_to_s2 (m1.DataToSlave, m1.addr, m1.RW);
		m1.DataFromSlave = s2.DataFromSlave;
		end
	
	32'hFFEF3210: begin
		send_to_s3 (m1.DataToSlave, m1.addr, m1.RW);
		m1.DataFromSlave = s3.DataFromSlave;
		end	
	default : begin
		s0.sel =0;
		s1.sel =0;
		s2.sel =0;
		s3.sel =0;
		end	
	endcase
	end*/
	
	if(m2.grant==1) begin
	case(m2.addr)
	32'hFFEF0220: begin
		send_to_s0 (m2.DataToSlave, m2.addr, m2.RW);
		m2.DataFromSlave = s0.DataFromSlave;
		end

	32'hFFEF1220: begin
		send_to_s1 (m2.DataToSlave, m2.addr, m2.RW);
		m2.DataFromSlave = s1.DataFromSlave;
		end
	
	32'hFFEF2220: begin
		send_to_s2 (m2.DataToSlave, m2.addr, m2.RW);
		m2.DataFromSlave = s2.DataFromSlave;
		end
	
	32'hFFEF3220: begin
		send_to_s3 (m2.DataToSlave, m2.addr, m2.RW);
		m2.DataFromSlave = s3.DataFromSlave;
		end	
	default : begin
		s0.sel =0;
		s1.sel =0;
		s2.sel =0;
		s3.sel =0;
		end	
	endcase
	end
	
	end
end

always @(posedge m0.clk) begin
	m0_amt <= #1 m0_amt_d;
	m1_amt <= #1 m1_amt_d;
	m2_amt <= #1 m2_amt_d;
	m3_amt <= #1 m3_amt_d;
	count_clk <= #1 count_clk_d;
	timer0 <= #1 timer0_d;
	timer1 <= #1 timer1_d;
	timer2 <= #1 timer2_d;
	timer3 <= #1 timer3_d;

end


///////////////// TASKS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

task send_to_s0 (input [31:0]DataToSlave, addr, RW);
	s0.DataToSlave = DataToSlave;
	s0.addr = addr;
	s0.RW = RW;
	s0.sel = 1'b1;
	s1.sel = 1'b0;
	s2.sel = 1'b0;
	s3.sel = 1'b0;
endtask

task send_to_s1 (input [31:0]DataToSlave, addr, RW);
	s1.DataToSlave = DataToSlave;
	s1.addr = addr;
	s1.RW = RW;
	s0.sel = 1'b0;
	s1.sel = 1'b1;
	s2.sel = 1'b0;
	s3.sel = 1'b0;
endtask

task send_to_s2 (input [31:0]DataToSlave, addr, RW);
	s2.DataToSlave =DataToSlave;
	s2.addr = addr;
	s2.RW = RW;
	s0.sel = 1'b0;
	s1.sel = 1'b0;
	s2.sel = 1'b1;
	s3.sel = 1'b0;
endtask

task send_to_s3 (input [31:0]DataToSlave, addr, RW);
	s3.DataToSlave = DataToSlave;
	s3.addr = addr;
	s3.RW = RW;
	s0.sel = 1'b0;
	s1.sel = 1'b0;
	s2.sel = 1'b0;
	s3.sel = 1'b1;
endtask



endmodule
