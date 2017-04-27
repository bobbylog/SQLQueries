		
			-- EXEC  master..xp_cmdshell 'md d:\JoanneFiles\chat'
			 EXEC  master..xp_cmdshell 'copy /b NUL > d:\JoanneFiles\chat\transcript.csv'
		     EXEC  master..xp_cmdshell 'echo conversation & echo. > d:\JoanneFiles\chat\transcript.csv'
	
	
	select 
				* 
	
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=d:\JoanneFiles\chat\' 
				 ,'select * from transcript.csv') T
				 
				 
				  EXEC  master..xp_cmdshell 'echo hello  >> d:\JoanneFiles\chat\transcript.csv'
	
		select 
				* 
	
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=d:\JoanneFiles\chat\' 
				 ,'select * from transcript.csv') T		
				 
				 
		
					  EXEC  master..xp_cmdshell 'echo how are you doing ? >> d:\JoanneFiles\chat\transcript.csv'
	
		select 
				* 
	
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=d:\JoanneFiles\chat\' 
				 ,'select * from transcript.csv') T		 
				 
		
				  EXEC  master..xp_cmdshell 'echo I''m fine >> d:\JoanneFiles\chat\transcript.csv'
	
		select 
				* 
	
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=d:\JoanneFiles\chat\' 
				 ,'select * from transcript.csv') T		
				 
				 		 