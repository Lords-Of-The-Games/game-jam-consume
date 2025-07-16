extends Node

@warning_ignore_start("unused_signal")
signal ability_used(which_ability)
signal took_damage(amount)
signal ability_selected_in_menu(which_ability)
signal opened_menu
signal menu_finished_slowing
signal received_message(original_message : String, new_message : String, delay : float, important : bool)
signal restart
