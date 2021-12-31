
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

data_base_dir = paste0(getwd(),'/data/',project_name,'/')

dt = NULL

bnf_codes = list(c('0212000B0AAACAC','Atorvastatin 40mg tablets'),
                 c('0212000Y0AAADAD','Simvastatin 40mg tablets'))

for (c in bnf_codes){
    
      q = paste0(
        "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month ,  count(*) as count, '",c[1],
        "' as bnf_presentation_code, mean(PrescribedQuantity) as average_quantity, sum(PrescribedQuantity) as total_quantity
        FROM ", tre_project_prefix ,'dispensed_key_groups_',tre_table_stamp_code,
        " WHERE PrescribedBNFCode  = '",c[1],"'
          GROUP BY Year(Event_Date), MONTH(Event_Date) "
      )
      
      cat(q,'\n')
      res <- dbGetQuery(con,q)
      setDT(res)
      res <- res[,paste0("bnf_presenation"):=c[2]]
      dt <- rbind(dt,res,fill=TRUE)
      
}

out_file <- eng_data_path_counts(data_base_dir,'dispensed','quantities')
save_dt_to_csv(dt, out_file)

