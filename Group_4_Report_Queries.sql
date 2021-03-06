--Report Queries Group 4--

--Query 1
Select  B.Bug_Id, B.Bug_Severity, DM.Emp_ID,  
        (E.Emp_First_Name || ' ' || E.Emp_Last_Name) AS "Employee_Name",  
        BM.BUG_RESOLVED_DATE, 
        abs(trunc(sysdate) - BM.BUG_RESOLVED_DATE) AS "No of Days since Bug resolved"  
        from bug_details B 
        join bug_management BM 
        on B.Bug_ID=BM.Bug_ID 
        join bug_fix_document BD 
        on B.Bug_ID = BD.Bug_ID 
        join Document_Management DM 
        on BD.Bug_Doc_ID = DM.Bug_Doc_ID 
        join Emp_Details E 
        on DM.Emp_ID=E.Emp_ID 
        where DM.Doc_Created_Date is not Null  
        and B.Bug_Status='Resolved' 
        order by B.Bug_ID; 

--Query 2
Select BD.bug_type, trunc(Avg(BM.bug_resolved_date - BM.bug_report_date)) as Avg_Bug_Fix_Duration, 
       count(*) as No_Of_bugs from bug_management BM  
       join bug_details BD 
       on BM.bug_id = BD.bug_id 
       group by bd.bug_type 
       order by Avg_Bug_Fix_Duration, No_Of_bugs desc 
; 

--Query 3
select * from game_details order by Game_release_date;
SELECT game_platform
from RUP21001.game_details
GROUP BY  game_platform
order by  Sum(Game_Sales) desc;

--Query 4
SELECT  
  EMP_ID, EMP_FIRST_NAME AS FIRST_NAME, EMP_LAST_NAME AS LAST_NAME, TO_CHAR(EMP_SALARY, '$999,999.00') AS ANNUAL_SALARY, BUG_COUNT, 
   (CASE  
    WHEN BUG_COUNT <10 AND BUG_COUNT > 0 THEN  TO_CHAR(BUG_COUNT*150, '$999,999.00') 
    WHEN BUG_COUNT <21 AND BUG_COUNT > 10 THEN  TO_CHAR(BUG_COUNT*150, '$999,999.00') 
    WHEN BUG_COUNT <31 AND BUG_COUNT > 20 THEN  TO_CHAR(BUG_COUNT*150, '$999,999.00') 
    ELSE TO_CHAR(BUG_COUNT*150, '$999,999.00') END) AS "EMPLOYEE BONUS" 

FROM ( 
    SELECT  
    D.EMP_FIRST_NAME, D.EMP_LAST_NAME, D.EMP_SALARY, B.EMP_ID, COUNT(BUG_ID) BUG_COUNT 
    FROM RUP21001.BUG_MANAGEMENT B 
    LEFT JOIN  RUP21001.EMP_DETAILS D 
    ON B.EMP_ID = D.EMP_ID 
    GROUP BY D.EMP_FIRST_NAME, D.EMP_LAST_NAME, D.EMP_SALARY, B.EMP_ID 
 ) 
 ORDER BY  
 BUG_COUNT DESC; 
 
--Query 5
select gd.game_name, bug_status, 
(
    case when bug_status = 'Commited' Then count(bug_status)
    when bug_status = 'Resolved' Then count(bug_status)
    when bug_status = 'Removed' Then count(bug_status)
    when bug_status = 'New' Then count(bug_status)
    when bug_status = 'Approved' Then count(bug_status)
    else 0
    end
)   as count
    from bug_details BD join game_details GD
    on bd.game_id = gd.game_id
    group by bug_status, gd.game_name
    order by gd.game_name
;
