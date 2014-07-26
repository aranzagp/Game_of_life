require 'gnuplot' #gem install gnuplot

dim_new=20;
#Define the array of zeros
arr_new=Array.new(dim_new) { Array.new(dim_new, 0) };
arr=Array.new(dim_new) { Array.new(dim_new, 0) };

print "Choose the number of the pattern do you want to start: \n1-Glider 2-Random 3-Blinker 4-Pulsar 
 5-Lightweight spaceship\n"
choose=gets.to_i
case choose

    when 1
        glider = [[3,2], [3,3], [3,4], [2,4], [1,3]];
        glider.each {|i,j| arr[i][j] = 1};
    when 2
        arr=Array.new(dim_new) { Array.new(dim_new, rand(2)) };
    when 3 
        blinker=[[3,2],[3,3],[3,4]];
        blinker.each {|i,j| arr[i][j] = 1};
    when 4
  		pulsar = [[2,5],[2,6],[2,7],[2,11],[2,12],[2,13],
				  [7,5],[7,6],[7,7],[7,11],[7,12],[7,13],
				  [9,5],[9,6],[9,7],[9,11],[9,12],[9,13],
				  [14,5],[14,6],[14,7],[14,11],[14,12],[14,13],
				  [4,3],[5,3],[6,3],[10,3],[11,3],[12,3],
				  [4,8],[5,8],[6,8],[10,8],[11,8],[12,8],
				  [4,10],[5,10],[6,10],[10,10],[11,10],[12,10],
				  [4,15],[5,15],[6,15],[10,15],[11,15],[12,15]]
		pulsar.each {|i,j| arr[i][j] = 1};
	when 5
		lss=[[12,13],[12,16],[13,12],[14,12],[14,16],[15,12],[15,13],[15,14],[15,15]]
		lss.each {|i,j| arr[i][j] = 1};
        
end

dim=arr.length-1;
#Open Gnuplot
Gnuplot.open do |gp|

for ciclo in 0..65    
x=[];
y=[];
for i in 0..dim #Start iterating over the rows
    for j in 0..dim #Start iterating over the columns

        cells = 0#Starts counting the cells arround each point
        if (i>0 and i<dim) and (j>0 and j<dim)               
        (-1..1).each do |a|
            (-1..1).each do |b|               
                unless (a==0) and (b==0)                   
                    if arr[i+a][j+b] == 1
                        cells += 1
                    end               
                end                
            end
        end
    	end
    	#New cell
        if arr[i][j]==0 and cells==3
            arr_new[i][j]=1;
        #The cell dies by underpopulation
        elsif arr[i][j]==1 and cells<2
            arr_new[i][j]=0;
        #The cell dies by overcrowding
        elsif arr[i][j]==1 and cells>3
            arr_new[i][j]=0;
        #The cell lives on to the next generation
        elsif arr[i][j]==1 and (cells==3 || cells==2)
            arr_new[i][j]=1;
        end
        

        if arr[i][j]==1#Save the coordinates where we have a cell
            x.push(i)
            y.push(j)
           
        end
    end
end
	#Plot the grid
  Gnuplot::Plot.new( gp ) do |plot|
    
    plot.title  "Game of life"
    plot.ylabel "y"
    plot.xlabel "x"
    plot.xrange "[-1:20]"
    plot.yrange "[-1:20]"
    #plot.grid
   

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      #ds.with = "linespoints"
      ds.notitle
    end
  end
  sleep 0.3

	if (x.empty? and y.empty?)#If we have an array of zeros, the process stops!
		break
	end

#The array becomes a new array in the next step
arr=arr_new;
arr_new=Array.new(dim_new) { Array.new(dim_new, 0) }
end
end
