require 'open3'

class Rimand
  def to_s1
    "ssh $USER@tinkercliffs2 sacct --format=jobid,jobname,ntasks,elapsed,state -u $USER"
  end

  AppProcess = Struct.new(:jobid, :jobname, :ntasks, :epalsed, :stat)

  def parse(output)
    lines = output.strip.split("\n")
    lines.map do |line|
      AppProcess.new(*(line.split(" ", 5)))
    end
  end
 
  def exec_jobstats
    items, error = [], nil
    stdout_str, stderr_str, status = Open3.capture3(to_s1)
    if status.success?
        items = parse(stdout_str)
    else
      error = "Command '#{to_s1}' exited with error: #{stderr_str}"
    end

    [items, error]
  end
end
