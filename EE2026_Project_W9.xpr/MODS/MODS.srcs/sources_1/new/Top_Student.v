`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////notes////////////////////////////////////////////////////////
///if you want to add new states, modify 1) state definition (add or modify state name, take note of #total state | register value) 2) clk selection 3)btn checking logic (add a state and clear value at IDLE) 4)OLED assignment 5)score system 6) 

module Top_Student (input clk,btnC,btnL,btnR,btnU,btnD,reset,output [7:0] JB,output reg [6:0]seg, output reg [3:0]an, output [9:0]led);
       
////////////////clk
reg insert_clk = 0;
wire clk_40hz, clk_6p25mhz,clk_1hz,clk_20hz,clk_200hz;
flexi_clk clk40hz (clk,32'd1249999,clk_40hz);
flexi_clk clk6p25mhz (clk,32'd7,clk_6p25mhz);
flexi_clk clk1hz(clk, 32'd49999999,clk_1hz);
flexi_clk clk20hz(clk, 32'd2499999,clk_20hz);
flexi_clk clk80hz (clk,32'd249999 ,clk_200hz);

/////////////////oled display
wire [12:0] pixel_index;
reg [15:0] oled_data;
wire sending_pixels,frame_begin,sample_pixel;
reg [7:0] col;
reg [7:0] row;
parameter [15:0] CYAN = 16'b0011011011011011,
                 BLACK = 0,
                 RED = 16'b1111100000000000,
                 YELLOW = 16'b1111111111100000,
                 ORANGE = 16'b1101110100000001,
                 MAGENTA = 16'b1100101011011101,
                 PINK = 16'b11111_000111_10011,
                 BLUE = 16'b00011_111011_10110;
                 
Oled_Display oled_display(clk_6p25mhz, 0, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data, JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);

///////////////////////////////////////////////////////////////states definition
reg [7:0] box_top = 0;
reg [7:0] triangle_top = 0;
reg [7:0] circle_top = 0;
reg [7:0] star_top = 0;
reg [7:0] ring_top = 0;
reg [7:0] hold_top = 0;

reg holdstate_status = 0;
reg hold_status = 0;
reg [31:0]hold_count = 0;
reg hold_check = 0;
reg [31:0] holdcheck_count = 0;

reg [3:0] state;
reg [13:0] score = 0;
parameter [3:0] 
        IDLE = 4'b0000,
        SQUARE = 4'b0001,
        CIRCLE = 4'b0010,
        RING = 4'b0011,
        MISSED = 4'b0100,
        STAR = 4'b0101,
        RESET = 4'b0110, 
        TRIANGLE = 4'b0111,
        HOLD = 4'b1000;
        
//////////////////////////////////////////////////////////////////////////7 segment 
reg [1:0] digit_select = 0;
reg [6:0] seg_value [0:9];
initial 
begin
        seg_value [0] = 7'b1000000; 
        seg_value [1] = 7'b1111001;
        seg_value [2] = 7'b0100100;
        seg_value [3] = 7'b0110000;
        seg_value [4] = 7'b0011001;
        seg_value [5 ]= 7'b0010010;
        seg_value [6] = 7'b0000010;
        seg_value [7] = 7'b1111000;
        seg_value [8] = 7'b0000000;
        seg_value [9] = 7'b0010000;
end
//BRAM initialisation

//////////////////////////////////////////////////////////////////////////health system
reg [9:0]health = 100;

HealthBar healthbar(health,clk,led);

parameter [3:0] SQUARE_DEDUCT = 4,
                TRIANGLE_DEDUCT = 1,
                CIRCLE_DEDUCT = 3,
                STAR_DEDUCT = 4,
                RING_DEDUCT = 2,
                HOLD_DEDUCT = 10;
                
//////////////////////////////////////////////////////////////////////////clk selection
always@(posedge clk)
begin
    if(state == SQUARE || state == CIRCLE)
    begin
        insert_clk <= clk_40hz;
    end
    if(state == TRIANGLE || state == STAR || state == RING)
    begin
        insert_clk <= clk_20hz;
    end
    else
    begin
        insert_clk <= clk_40hz;
    end
end

//////////////////////////////////////////////////////////////////////////////btn checking logic
always@(posedge insert_clk)
begin
 
    if(health < 10'd1)
    begin
        state <= MISSED;
    end
    
    ///////////////////////////////////////////////////////////////////////////////RESET state
    if (reset)
    begin
        state <= RESET;
    end
    
    else 
    begin
    case(state)
        RESET:
        begin
            score <= 0;
            health <= 10'd100;
                if(!reset)begin
                    state <= IDLE;
                end
        end
        
        ///////////////////////////////////////////////////////////////////IDLE STATE
        IDLE:
        begin
            health <= 10'd100;
            box_top <= 0;
            triangle_top <= 0;
            circle_top <= 0;
            star_top <= 0;
            ring_top <= 0;
            hold_top <= 0;
            score <= 0;
                if(btnC)
                begin
                    state <= SQUARE;
                end
        end   
        
        //////////////////////////////////////////////////////////////SQUARE STATE
        SQUARE:
        begin
            circle_top <= 0;triangle_top <= 0;star_top <= 0;ring_top <= 0; holdstate_status <= 0;
                if(box_top < 42)///add a leeway of 3 pixels, 42 is hitting the bottom
                begin
                    box_top <= box_top + 1;
                end
                if(box_top >=37 && box_top <= 42)
                begin
                    if(btnU)
                    begin
                        score <= score + 1;
                        state <= TRIANGLE;
                    end
                    else if(box_top == 42)
                    begin
                        health <= (health > SQUARE_DEDUCT)?(health - SQUARE_DEDUCT):0;     
                        state <= TRIANGLE;
                    end
                end
        end
        
        /////////////////TRIANGLE STATE
        TRIANGLE:
        begin
            if(triangle_top < 37)
            begin
                triangle_top <= triangle_top + 1;
            end
            if(triangle_top >= 32 && triangle_top <= 37)
            begin
                if(btnD)
                begin
                    score <= score + 2;
                    state <= CIRCLE;
                end
                else if (triangle_top == 37)
                begin
                    health <= (health > TRIANGLE_DEDUCT)?(health - TRIANGLE_DEDUCT):0;
                    state <= CIRCLE;
                end
            end
        end
        
        /////////////////CIRCLE STATE
        CIRCLE:
        begin
            if(circle_top < 47)
            begin
                circle_top <= circle_top + 1;
            end
            if(circle_top >= 42 && circle_top <= 47)
            begin
                if(btnL)
                begin
                    score <= score + 4;
                    triangle_top <= 0;
                    state <= STAR;
                end
                else if(circle_top == 47)
                begin
                    health <= (health > CIRCLE_DEDUCT)?(health - CIRCLE_DEDUCT):0;
                    state <= STAR;
                end
            end
        end
        
        ////////////////////////////////////////////////////////////STAR STATE
        STAR:
        begin
            if(star_top < 47)
            begin
                star_top <= star_top + 1;
            end
            if(star_top >= 42 && star_top <= 47)
            begin
                if(btnU && btnL)
                begin
                    score <= score + 6;
                    circle_top <= 0;
                    state <= RING;
                end
                else if(btnU || btnL || btnU || btnD)
                begin
                    health <= (health > STAR_DEDUCT)?(health - STAR_DEDUCT):0;
                end else if(star_top == 47)
                begin
                    health <= (health > STAR_DEDUCT)?(health - STAR_DEDUCT):0;
                    state <= RING;
                end    
            end
        end
        
        /////////////////////////////////////////////////////////////RING STATE
        
        RING:
        begin
            if(ring_top < 47)
            begin
                ring_top <= ring_top + 1;
            end
            if(ring_top >= 42 && ring_top <= 47)
            begin
                if(btnU && btnD)
                begin
                    score <= score + 8;
                    star_top <= 0;
                    state <= SQUARE;
                end
                else if(ring_top == 47)
                begin
                    box_top <= 0;
                    hold_top <= 0;
                    health <= (health > RING_DEDUCT)?(health - RING_DEDUCT):0;
                    state <= HOLD;
                end    
            end       
        end
        
        /////////////////////////////////////////////////////////HOLD state
        
        HOLD:
        begin
            if(hold_top < 47)
            begin
                hold_top <= hold_top + 1;
            end
            if(hold_top > 42 && hold_top <= 47)
            begin
                holdstate_status <= 1;
                if(hold_check)
                begin
                    if(hold_count <=299999999 && hold_count >= 99999999)//between 3 seconds and 1 second
                    begin
                        score <= score + 100;
                        state <= SQUARE;
                    end
                    else 
                    begin
                         health <= (health > HOLD_DEDUCT)?(health - HOLD_DEDUCT):0;
                        state <= SQUARE;
                    end
                end
            end
        end
        
        /////////////////MISSED STATE
        MISSED:
        begin
            if(btnR)
            begin
                state <= IDLE;
            end
        end
        
        default:state<=RESET;
        
    endcase
    end
end

////////////////////////////////////////////////////////////hold timer
always@(posedge clk)
begin
    if(holdstate_status)
    begin
        if(btnU)/////i don't think this is hold
        begin
            hold_count<= (hold_count == 299999999)?0:hold_count + 1;
        end
        else 
        begin
            hold_count <= 0;
        end
    end
end

always@(posedge clk)
begin   
    if(holdstate_status)
    begin
        holdcheck_count<= (holdcheck_count == 299999999)?0:holdcheck_count + 1;
        if(holdcheck_count == 299999999)
        begin
            hold_check <= 1;
        end 
    end
    else 
    begin
        holdcheck_count <= 0;
        hold_check <= 0;
    end 
end











///////////////////////////////////////////////////////////////////////////////////OLED Assignment
always@(posedge clk_6p25mhz)
begin
    col <= pixel_index % 96;
    row <= pixel_index / 96;
    
    if (state == IDLE)
    begin
        if(col <= 25 && col > 10 && row >0 && row<=15)
        begin
            oled_data <= CYAN;
        end
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == RESET)
    begin
        if((row == 10 && col >= 40 && col <= 50) ||                 
                         (row == 15 && col >= 40 && col <= 50) ||                 
                         (row == 25 && col >= 40 && col <= 50) ||                 
                         (col == 40 && row >= 10 && row <= 15) ||                 
                         (col == 50 && row >= 15 && row <= 25))
        begin
            oled_data <= RED;
        end
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if (state == SQUARE)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=10 && col<25 && row >= box_top && row < box_top + 15)
        begin
            oled_data <= CYAN;
        end
        else
        begin
            oled_data <= BLACK;
        end  
    end
    
    if(state == MISSED)
    begin
        if((col<60 && 30<col && row>50 && row<60)||(col>28 && col<=30 && row<60 && row>15))
        begin
            oled_data <= RED;
        end
        else
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == TRIANGLE)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=50 && col<70 && row >= triangle_top && row < triangle_top + 20)
        begin
            oled_data <= RED;
        end 
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == CIRCLE)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=30 && col<50 && row >= circle_top && row < circle_top + 10)
        begin
            oled_data <= MAGENTA;
        end 
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == STAR)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=30 && col<50 && row >= star_top && row < star_top + 10)
        begin
            oled_data <= PINK;
        end 
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == RING)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=10 && col<50 && row >= ring_top && row < ring_top + 10)
        begin
            oled_data <= BLUE;
        end 
        else 
        begin
            oled_data <= BLACK;
        end
    end
    
    if(state == HOLD)
    begin
        if (col<80 && col>=5 && row >= 58 && row <=60)
        begin
            oled_data <= YELLOW;
        end
        else if(col>=30 && col<60 && row >= hold_top && row < hold_top + 10)
        begin
            oled_data <= YELLOW;
        end 
        else 
        begin
            oled_data <= BLACK;
        end
    end
    ///other states
end

//////////////////////////////////////////////////////////////////////////////////score system
always@(posedge clk_200hz)
begin

    case(state)
        RESET:
        begin
            an[3:0] <= 4'b1111;
            seg[6:0] <= 7'b1111111;
        end
        
        IDLE:
        begin
            an[3:0] <= 4'b1110;
            seg[6:0] <= 7'b1111110;
        end
        
        SQUARE,TRIANGLE,CIRCLE,STAR,RING,HOLD,MISSED:
        begin
            case(digit_select)
                    2'b00: begin
                        if (score >= 1000) begin
                            an <= 4'b0111; 
                            seg <= seg_value[(score / 1000) % 10]; 
                        end 
                    end   
                    
                    2'b01: begin
                        if(score >= 100) begin
                            an <= 4'b1011; 
                            seg <= seg_value[(score / 100) % 10]; 
                        end 
                    end
                    
                    2'b10: begin
                        if (score >= 10) begin
                            an <= 4'b1101; 
                            seg <= seg_value[(score / 10) % 10]; 
                        end 
                    end   
                        
                    2'b11: begin    
                        an <= 4'b1110; 
                        seg <= seg_value[score % 10]; 
                    end
                endcase 
   
                digit_select <= digit_select + 1; 
               
            end
        default:
        begin
            an[3:0] <= 4'b1111;
            seg[6:0] <= 7'b1111111;
        end
    endcase
end

endmodule