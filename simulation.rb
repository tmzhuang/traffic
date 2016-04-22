module Statistics
  require_relative 'exp'
  require_relative 'event_factory'
  require 'rubygems'
  require 'byebug'
  class Simulation
    def initialize(lam, b, mew)
      @lam = lam
      @b = b
      @mew = mew
      get_data_from_files
      init_state
    end

    def test
      5.times do |i|
        init_state
        name = "test#{i}.txt"
        f = File.open(name, 'w')
        1000.times do
          f.puts generate_service_time
        end
      end
    end

    def init_state
      @interarrivals = Array.new(@interarrivals_base )
      @services = Array.new(@services_base)

      @interarrival_generator = Exp.new(@lam, 0.7, @b)
      @service_generator = Exp.new(@mew, 0.7, 0.5)
      @event_factory = EventFactory.new
      @clock = 0
      @queue = []
      @server = []
      @fel = []
      @frames = []
      @packets_served = 0
      @packets_created = 1

      #stats
      @departures = 0
      @server_busy_time = 0
    end

    def get_data_from_files
      @interarrivals_base, @services_base = [], []
      CSV.foreach("./data/interarrivals.csv", converters: :numeric) do |input_csv|
        @interarrivals_base << input_csv[0]
      end
      CSV.foreach("./data/services.csv", converters: :numeric) do |input_csv|
        @services_base << input_csv[0]
      end
    end

    def run(reps=1)
      timestring = Time.now.to_i
      dir = "#{timestring}_lam#{@lam}_b#{float_to_underscore(@b)}_mew#{@mew}_results"
      Dir.mkdir(dir)
      reps.times do |i|
        init_state

        # create first arrival
        @fel << @event_factory.build(:arrival, 0)

        # Run simulation
        while @packets_created <= 100000
          event = @fel.shift
          handle_event(event)
        end

        # Output results
        title = "rep#{i+1}_#{timestring}_lam#{@lam}_b#{float_to_underscore(@b)}_mew#{@mew}_results"
        filename = "#{dir}/#{title}.csv"
        # Write column title
        CSV.open(filename, 'w') do |csv|
          csv << [ title ]
        end
        # Write data
        CSV.open(filename, 'a') do |csv|
          @frames.each_with_index do |frame, i|
            csv << [frame]
          end
        end
      end
    end

    def handle_event(event)
      case event.type
      when :arrival
        handle_arrival(event)
      when :departure
        handle_departure(event)
      end
    end

    def sort_fel
      @fel.sort_by! do |event|
        event.time
      end
    end

    def handle_arrival(event)
      @packets_created += 1
      #p "Handling arrival: #{event}"
      @clock = event.time
      # If server is empty, serve the customer and generate departure event
      if @server.empty?
        #p "Server is empty, generating departure time for cid: #{event.cid}"
        @server << event.cid
        service_time = generate_service_time
        departure_time = @clock + service_time
        @fel << @event_factory.build(:departure, departure_time, @server.first)
        sort_fel
      else
        # Otherwise, put customer in queue
        #p "Server is full, putting into queue cid: #{event.cid}"
        @queue << event.cid
      end

      # Generate next arrival
      arrival_time = @clock + generate_interarrival_time
      @fel << @event_factory.build(:arrival, arrival_time)
      sort_fel

      # collect statistics
      util = 'na'
      util = @server_busy_time / @clock unless @clock == 0
      @frames << @queue.size + @server.size
      #@frames << { time: @clock,
                   #event_type: event.type,
                   #fel: get_fel_copy,
                   #queue_size: @queue.size,
                   #departures: @departures,
                   #utilization: util
      #}
      @server_busy_time += service_time if service_time
    end

    def get_fel_copy
      fel_copy = []
      @fel.each do |event|
        fel_copy << event
      end
      fel_copy
    end

    def handle_departure(event)
      #p "handling departure: #{event}"
      @clock = event.time
      @server.pop
      if !@queue.empty?
        #p "queue has items..."
        @server << @queue.shift
        #p "generating depature for cid: #{@server.first}"
        departure_time = @clock + generate_service_time
        @fel << @event_factory.build(:departure, departure_time, @server.first)
        sort_fel
      end

      #collect stats
      util = @server_busy_time / @clock
      @departures += 1
      #@frames << @queue.size + @server.size
      #@frames << { time: @clock,
                   #event_type: event.type,
                   #fel: get_fel_copy,
                   #queue_size: @queue.size,
                   #departures: @departures,
                   #utilization: util
      #}

      @packets_served += 1
    end

    def generate_service_time
      if @services.empty?
        @service_generator.generate
      else
        @service_generator.transform(@services.shift)
      end
    end

    def generate_interarrival_time
      if @interarrivals.empty?
        @interarrival_generator.generate
      else
        @interarrival_generator.generate(@interarrivals.shift)
      end
    end

    def float_to_underscore(float)
      float.to_s.gsub(".","_")
    end

    def get_intearrivals_from_file(lam, b)
      filename = "./interarrival_lambda_#{lam}_ab_#{float_to_underscore(b)}.csv"
      get_ary_from_col('interarrival_times', filename)
    end

    def get_services_from_file(mew)
      filename = "service_mew_#{mew}.csv"
      get_ary_from_col( 'service_times' , filename)
    end

    def get_ary_from_col(col_name, filename)
      result = []
      CSV.foreach(filename, converters: :numeric, headers: true) do |csv|
        result << csv[col_name]
      end
      result
    end

    def create_interarrival_histogram(lam, eps, b, a=b*-1) 
      generator = Exp.new(lam, eps, b, a)
      filename = "./interarrival_lambda_#{lam}_ab_#{float_to_underscore(b)}.csv"
      CSV.open(filename,"w") do |csv|
        csv << ['interarrival_times']
      end
      @interarrivals.each do |interarrival|
        CSV.open(filename,"a") do |csv|
          csv << [ generator.generate(interarrival) ]
        end
      end
    end

    def create_service_histogram(mew)
      generator = Exp.new(mew, 1, 0.5)
      filename = "./service_mew_#{mew}.csv"
      CSV.open(filename,"w") do |csv|
        csv << ['service_times']
      end
      @services.each do |service|
        CSV.open(filename,"a") do |csv|
          csv << [ generator.transform(service) ]
        end
      end
    end

    private
    def run_interarrivals
      e = []
      # Create interarrival output files and generators
      5.times do |i|
        # Create file
        n = 2*i + 1
        CSV.open("./interarrival_lambda_#{n}.csv","w") do |csv|
          csv << ['interarrival_times']
        end
        # Initialize generator
        e << Exp.new(n, 0.7, 0.5)
      end

      # get interarrivals from csv
      CSV.foreach("interarrivals.csv", converters: :numeric) do |input_csv|
        5.times do |i|
          n = 2*i + 1
          CSV.open("./interarrival_lambda_#{n}.csv","a") do |output_csv|
            output_csv << [ e[i].generate(input_csv[0]) ]
          end
        end
      end
    end

    if __FILE__ == $0
      lam, b, mew = 7, 0.5, 10
      # 7, 0.5, 10
      sim = Simulation.new(lam, b, mew)
      sim.run(20)
      #9, 0.5, 10
      lam = 9 
      sim = Simulation.new(lam, b, mew)
      sim.run(20)
      # 9, 0.1, 10
      b = 0.1
      sim = Simulation.new(lam, b, mew)
      sim.run(20)
      # 7, 0.1, 10
      lam = 7 
      sim = Simulation.new(lam, b, mew)
      sim.run(20)
    end
  end
end
