require 'open3'

class Command
  def new_file
    "./batch_job_n.sh"
  end

  def to_s
    "ssh $USER@tinkercliffs2 sbatch " + Dir.getwd + new_file
  end


  AppProcess = Struct.new(:jobid)

  def format(src,dest)
    filen = "./batch_job.sh"
    text = File.read(filen)
    new_text = text.gsub(/r_dst/,dest)
    new_text = new_text.gsub(/r_src/,src)
    File.write(new_file,new_text,mode: 'a')
  end
  def parsejobid(output)
    jobid = output.strip.split(" ")[3]
    [jobid]
  end

  # Execute the command, and parse the output, returning and array of
  # AppProcesses and nil for the error string.
  #
  # returns [Array<Array<AppProcess>, String] i.e.[processes, error]
  def exec(src,dest,actions,folder)
    
    format(src,dest)
    processes, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(to_s)
    if status.success?
      processes = parsejobid(stdout_str)
      
    else
      error = "Command '#{to_s}' exited with error: #{stderr_str}"
    end

    [processes, error]
  end
end