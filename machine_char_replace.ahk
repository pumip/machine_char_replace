
; 機種依存文字を普通の文字に置換する関数
machine_char_replace(str, flag_replace_wavedash:=false) {

	; 何故かAHKだとU+D8系の文字を処理できないのでリストからは除外
	
	Ifnotexist, %A_scriptdir%\lib\hankana_list.csv
		throw "機種依存文字一覧ファイルmachine_char_list.csvを" . A_scriptdir . "\lib\フォルダに配置してください"
		
	arr_list    :=[]
	loop, read, %A_scriptdir%\lib\machine_char_list.csv
	{
        ; shiftjisのcsvでは0xFF5Eの「〜」が文字化けするためデフォルトで置換無効にする
        if (!flag_replace_wavedash && Instr(A_loopReadLine, "\x{FF5E}")) {
            continue
        }
        
		arr_row         :=strsplit(A_LoopReadLine, ",")
		replace_codes   :=[]
		while (arr_row.HasKey(A_index + 1)) {
			replace_codes.push(arr_row[A_index + 1])
		}
		arr_list.push({"pattern": arr_row[1], "replace": replace_codes})
	}

	For, key, val in arr_list {
		replace_texts   :=""
		while (val["replace"].HasKey(A_index)) {
			replace_texts   .=chr(val["replace"][A_index])
		}
		str	:=Regexreplace(str, "" . val.pattern . "", "" . replace_texts . "")
	}
	return str
}
return
