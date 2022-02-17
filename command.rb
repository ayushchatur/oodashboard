require 'open3'

class Command
  def new_file
    "/tar_job_n.sh"
  end

  def to_s2
    "ssh $USER@tinkercliffs2 sbatch " + Dir.getwd
  end


  AppProcess = Struct.new(:jobid)

  def format(src,dest)
    filen =  "./tar_job.sh"
    text = File.read(filen)
    new_text = text.gsub(/r_dest/,dest)
    new_text = new_text.gsub(/r_src/,src)
    File.write("."+new_file,new_text,mode: 'a')
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
    jobid, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(to_s2 + new_file)
    if status.success?
      jobid = parsejobid(stdout_str)
      
    else
      error = "Command '#{to_s2}' exited with error: #{stderr_str}"
    end

    [jobid, error]
  end
end