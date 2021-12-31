# CCU014

# set run variables
update file src/run_variables

#create data output dirs
run src/create_output_dirs_timestamped

# IMPORTANT!! copy Scotland and Wales data

# create England data from tre tables
run src/create_data/england_tre_data
run src/create_data/england_tre_quantities
run src/create_data/counts
run src/create_data/counts_linked_unlinked


#MAKE SURE SCO AND WALES DATA is in /data/ folders
run src/create_data/split_data_wales_scotland

# combine countries
run src/create_data/combine_data

#run analysis
run src/create_data/table1_prevalant
run src/create_data/table_2
run src/create_data/table_quantites
run src/create_data/pct_changes_key_group

#plot data
run src/plots/plot_data
