
module ahbtoapb2(
	//AHB�ź�
	           //�����˵�����
	            input		      HSEL,
	            input [31:0]      HADDR,
	            input             HWRITE,
	            input [2:0]       HSIZE,
	            input [2:0]       HBURST,
	            //input [3:0]       HPROT,//��֧�ָ��ź�
	            input [1:0]       HTRANS,
	           // input             HMASTLOCK,//��֧�ָ��ź�
	            input            HREADYIN,//�����ź�Ϊ�ߵ�����²ſ��Բ�����ַ�Ϳ����ź�
	            input [31:0]      HWDATA,
	            input             HRESETn,
	            input             HCLK,
	            //////////////////////////////////////////////////////////
	            //������Ǹ��ӻ���
	            //HREADYOUT �ź��ɴӻ���������д����ʱ���ӻ��ܱ���HWDATA��������Ѹ�
	            //�ź����ߣ�����Ϊ���ʱ�����ͻᱣ��д�����ϵ����ݲ��䣻�ڶ�����ʱ
	            //�ӻ��ܰ������͵��������������ߡ����ź�Ӧ�������ߵ�HREADY�ź���������
	            //�����ж���ӻ�������Ҫ��ַ���������ӵ�HREADY�ź����ϣ�
	            //ÿһ��AHB slave��HREADOUT �ź�����֮����Ҫ����HREADYIN�źš�����
	            //Ϊ�˱�����ΪAHB��ˮ���������µ�һ�����⣬
	            //https://blog.csdn.net/weixin_42208307/article/details/112913587
	            output reg              HREADYOUT,
	            output reg[1:0]       HRESP,//���ǻظ�ok
	            output reg[31:0]      HRDATA,
	         
	   //APB�ź�//////////////////////////////////////////////
	            output reg[31:0]      PADDR,
	            output  reg           PSEL,
	            output reg            PENABLE,
	            output  reg           PWRITE,
	            output reg[31:0]      PWDATA,
	            ////////////////////////////////////////////
	            //�ӻ��˵�����
	            
	            input              PREADY,
	            //input              PSLVERR,//��֧�ִ�����Ӧ
	            input [31:0]       PRDATA
	);
	parameter IDLE=0,AHB_DATA_WRITE=1,APB_PENABLE1=2,WRITE_READ_MEDIUM=3,APB_PENABLE2=4,
	          WRITE_READ=5,APB_PENABLE3=6,AHB_READ=7,WAIT=8,APB_PENABLE4=9;
	
	reg [3:0]cs,ns;
	reg [31:0]haddr_reg;
	reg hwrite_reg;
	reg slave_sel_reg;
	//�ӻ�ѡ�����źţ�ֻ�и��ź�Ϊ������ĵ�������Ҫ����
	wire slave_sel;
	wire s_w;
	wire s_r;
	assign s_w = slave_sel & HWRITE;//д����
	assign s_r = slave_sel & (!HWRITE);//������
	assign slave_sel = HSEL & HTRANS[1] & HREADYIN;
	always@(posedge HCLK or negedge HRESETn)begin
		if(!HRESETn) cs <= IDLE;
		else cs <= ns;
	end
	
	always@(*)begin
		case(cs)
			IDLE:begin
				if(s_w) ns = AHB_DATA_WRITE;
				else if(s_r) ns = APB_PENABLE3;
				else ns = IDLE;
			end
		    AHB_DATA_WRITE:begin
			     ns = APB_PENABLE1;
			    
			   
		    end
		    APB_PENABLE1:begin
			    if(hwrite_reg) ns = AHB_DATA_WRITE;
			    else if(!hwrite_reg) ns = WRITE_READ_MEDIUM;
			    else if((!s_w) & (!s_r) & slave_sel_reg) ns = WAIT;
			    else ns = IDLE;
		    end
		    WAIT:begin
			    ns = APB_PENABLE4;
		    end
		    APB_PENABLE4:begin
			    ns = IDLE;
			    end
		    WRITE_READ_MEDIUM:begin
			    ns = APB_PENABLE2;
		    end
		    APB_PENABLE2:begin
			    ns = WRITE_READ;
		
		    end
		    WRITE_READ:begin
			   if(s_r) ns = APB_PENABLE2;
			   else if(s_w) ns = AHB_DATA_WRITE;
			   else ns = IDLE;
		    end
		    APB_PENABLE3:begin
			    ns = AHB_READ;
		    end
		    AHB_READ:begin
			    if(s_r) ns = APB_PENABLE3;
			    else if(s_w) ns = AHB_DATA_WRITE;
			    else ns = IDLE;
		    end
		    
			default: ns = IDLE;
			
		endcase
		end
	
	always@(posedge HCLK or negedge HRESETn)begin
		if(!HRESETn)begin
			//��λʱHREADYOUT Ϊ1
			HREADYOUT <= 1;
		end
		else begin
			if(cs == IDLE)begin
				PENABLE <= 0;
				if(s_w)begin
					haddr_reg <= HADDR;
					hwrite_reg <= HWRITE;
					HREADYOUT <= 1;
					PSEL <= 0;
					PENABLE <= 0;
				end
				else if(s_r)begin
					PADDR <= HADDR;
					PWRITE <= HWRITE;
					PSEL <= 1;
					PENABLE <= 0;
					HREADYOUT <= 0;
					end
			end
			else if(cs == AHB_DATA_WRITE)begin
				
				PADDR <= haddr_reg;
				PWRITE <= hwrite_reg;
				HREADYOUT <= 0;
				if(slave_sel)begin
				haddr_reg <= HADDR;
				hwrite_reg <= HWRITE;
				slave_sel_reg <= 1;
				end
				else slave_sel_reg <= 0;
			    PWDATA <= HWDATA;
				PSEL <= 1;
				PENABLE <= 0;
				
				
				
				
				
			end
			else if(cs ==APB_PENABLE1)begin
				PENABLE <= 1;
				if(hwrite_reg) HREADYOUT <= 1;
				else if(s_r | !hwrite_reg)HREADYOUT <= 0;
				else if((!s_w) & (!s_r) & slave_sel_reg)HREADYOUT <= 0;
				else HREADYOUT <= 1;
				
			end
			else if(cs == WAIT)begin
				PENABLE <= 0;
				HREADYOUT<= 0;
				PADDR<= haddr_reg;
				PWRITE<= hwrite_reg;
				if(hwrite_reg) PWDATA<= HWDATA;
			end
			else if(cs == APB_PENABLE4)begin
				PENABLE<= 1;
				HREADYOUT <=1;
				end
			else if(cs == WRITE_READ_MEDIUM)begin
				PADDR <= haddr_reg;
				PWRITE <= hwrite_reg;
				if(hwrite_reg)PWDATA <= HWDATA;
				PSEL <= 1;
				PENABLE <= 0;
				HREADYOUT <= 0;
			end
			else if(cs == APB_PENABLE2)begin
				PENABLE <= 1;
				HREADYOUT <= 1;
			end
			else if(cs == WRITE_READ)begin
				PENABLE <= 0;
				
				if(s_r)begin
					PADDR <= HADDR;
					PWRITE <= HWRITE;
					HREADYOUT <= 0;
				end
				else if(s_w)begin
					haddr_reg <= HADDR;
				    hwrite_reg <= HWRITE;
					HREADYOUT <= 1;
					end
			end
			else if(cs == APB_PENABLE3)begin
				PENABLE <= 1;
				HREADYOUT <= 1;
			end
			else if(cs == AHB_READ)begin
				PENABLE <= 0;
				if(s_r)begin
					HREADYOUT <= 0;
					PADDR <= HADDR;
					PWRITE <= HWRITE;
				end
				else if(s_w)begin
					HREADYOUT <= 1;
					haddr_reg <= HADDR;
					hwrite_reg <= HWRITE;
					end
			end		
	end
	end
	
	always@(*)begin
	 HRDATA = PRDATA;
		end
	
	
	
	
	
	
	
	
endmodule