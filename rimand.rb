require 'open3'

class Rimand
  def to_s
    "ssh $USER@tinkercliffs2 sbatch " + Dir.getwd + "/batch_job.sh"
  end

  def job_status
    "ssh $USER@tinkercliffs2 sacct --format=jobid,jobname,ntasks,elapsed,state  -u $USER"
  end

  # AppProcess = Struct.new(:user, :pid, :pct_cpu, :pct_mem, :vsz, :rss, :tty, :stat, :start, :time, :command)
  AppProcess = Struct.new(:jobid, :jobname, :ntasks, :epalsed, :stat)
  # Parse a string output from the `ps aux` command and return an array of
  # AppProcess objects, one per process
  def parse(output)
    lines = output.strip.split("\n")
    lines.map do |line|
      AppProcess.new(*(line.split(" ", 5)))
    end
  end
  def parsejobid(output)
    jobid = output.strip.split(" ")[3]
    [jobid]
  end

  # Execute the command, and parse the output, returning and array of
  # AppProcesses and nil for the error string.
  #
  # returns [Array<Array<AppProcess>, String] i.e.[processes, error]
  def format()
    filen = "./batch_job.sh"
    text = File.read(filen)
    new_text = text.gsub(/r_dst/,"/home/ayushchatur/qu_wq")
    new_text = new_text.gsub(/r_src/,"/home/ayushchatur/a.sh")
    File.open(filen,"w"){|file| file.puts new_text} 
  end

  def exec_jobstats
    format()
    items, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(job_status)
    if status.success?
        items = parse(stdout_str)
    else
      error = "Command '#{to_s}' exited with error: #{stderr_str}"
    end

    [items, error]
  end
end
