// Auto-generated global bind file for plain_prompt

bind present_encryptor_top present_encryptor_top_sva_global u_present_encryptor_top_sva_global (
    .key_update_data_i(present_cipher_key_update.data_i),
    .key_update_data_o(present_cipher_key_update.data_o),
    .key_update_round_counter(present_cipher_key_update.round_counter),
    .sub_per_data_i(present_cipher_sp.data_i),
    .sub_per_data_o(present_cipher_sp.data_o),
    .top_clk_i(clk_i),
    .top_data_i(data_i),
    .top_data_load(data_load),
    .top_data_o(data_o),
    .top_key(key),
    .top_key_load(key_load),
    .top_key_update_output(key_update_output),
    .top_round_counter(round_counter),
    .top_sub_per_input(sub_per_input),
    .top_sub_per_output(sub_per_output)
);
