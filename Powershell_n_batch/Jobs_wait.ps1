start-job -Name Wait -ScriptBlock {sleep 50}
echo "Started job"
get-job -name Wait|wait-job
echo "Completed job"
remove-job -name wait