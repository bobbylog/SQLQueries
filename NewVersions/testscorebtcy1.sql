		    
						--update dbo.testscorebatch set Authorized=1 --where owneruid=123838
						--where Authorized=0 and (owneruid is not null and owneruid >0)
						--and BNum=dbo.getSScoreBatchNum()
						
						--delete from CAMS_testscore1
						--delete  from cams_testscore2
						--	delete from CAMS_test1
							
									declare @name2 varchar(50)
									declare @name3 varchar(50)
									declare @name4 varchar(50)
									declare @name5 varchar(50)
									declare @name6 varchar(50)
									declare @name7 varchar(50)
									declare @name8 varchar(50)


											DECLARE db_cursor1 CURSOR FOR  
												select OwnerUID, TestDate, TestName, Score1, Percentile, Authorized , BNum
												from dbo.testScoreBatch1
												where Authorized=1 and (owneruid is not null and owneruid >0)
												and BNum=23
												order by OwnerUID asc
												
												OPEN db_cursor1
												FETCH NEXT FROM db_cursor1 INTO @name2, @name3, @name4, @name5, @name6, @name7, @name8

												WHILE @@FETCH_STATUS = 0   
												BEGIN   
													Exec dbo.InsertStudentScoresFromAccOrgTest @name2,  @name3,  @name4,  @name5,  @name6, @name7


													   FETCH NEXT FROM db_cursor1 INTO   @name2, @name3, @name4, @name5, @name6, @name7, @name8
												END   

												CLOSE db_cursor1  
											DEALLOCATE db_cursor1

											
			    
			    