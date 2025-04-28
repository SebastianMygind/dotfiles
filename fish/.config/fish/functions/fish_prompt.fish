function fish_prompt -d "Function to display prompt."
	string join '' -- (set_color green) '[' $USER ']' \
	(set_color blue) '[' (prompt_pwd) ']'
	echo '> ' (set_color normal)
end
