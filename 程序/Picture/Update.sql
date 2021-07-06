/*
	说明: 在原存储过程中添加字段-2021-07-01
	FreeDom03 配置【产品名称】	
	FreeDom01 配置【产品规格】
	FreeDom02 配置【张数	
	Qty	销售表数量
	price	销售表单价
	comment 销售表行摘要
	
	
*/
/*
	------执行
	declare @p11 int
	set @p11=0
	exec p_XIWA_ReaccountQueryPtype N'00000',N'00000','2021-06-01','2021-07-31',N'00001',0,0,50,0,N'',@p11 output
	select @p11

*/
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].p_XIWA_ReaccountQueryPtype_25000018') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
  DROP PROCEDURE p_XIWA_ReaccountQueryPtype_25000018
GO
create PROCEDURE [dbo].[p_XIWA_ReaccountQueryPtype_25000018]    
(    
  @szBTypeID NVARCHAR(60) ,    
  @szPTypeID NVARCHAR(60) ,    
  @szBeginDate CHAR(10) ,    
  @szEndDate CHAR(10) ,    
  @OperatorID NVARCHAR(25) ,    
  @showOver INT ,  -- 是否显示未结算完成的明细行 1显示 0不显示    
  @IsPaging INT = 0 ,--0为不分,1为分页    
  @PageSize INT = 50 ,--每页显示数量    
  @PageIndex INT = 0 ,--第几页    
  @PageFilter NVARCHAR(MAX) = '' ,    
  @PageTotal INT = 0,  
  @showType INT OUTPUT     
)    
As    
begin    
  SET NOCOUNT ON    
  IF @szBTypeID = '00000'    
    SELECT  @szBTypeID = ''    
  SELECT  @szBTypeID = @szBTypeID + '%'    
  IF @szPTypeID = '00000'    
    SELECT  @szPTypeID = ''    
  SELECT  @szPTypeID = @szPTypeID + '%'    
  SELECT  CTypeID AS BtypeId    
  INTO    #Brights    
  FROM    dbo.GetUserCrights(@OperatorID)    
  SELECT  DTypeID    
  INTO    #Drights    
  FROM    dbo.GetUserDrights(@OperatorID)    
  SELECT  PTypeID    
  INTO    #Prights    
  FROM    dbo.GetUserPrights(@OperatorID)    
  SELECT  *    
  INTO    #BillPtypeDly    
  FROM    ( SELECT  Vchcode, Vchtype, Dlyorder, d.PtypeId, Blockno, Prodate, Total AS tax_total  
   ,FreeDom03='',FreeDom01='',FreeDom02='',Qty=0,price='',comment=''      
            FROM    DlyARAPIni d    
            INNER JOIN #Prights p    
            ON      d.PtypeId = p.PTypeID    
            WHERE   ( @szPTypeID = '%'    
                      OR d.PtypeId LIKE @szPTypeID )    
            UNION ALL    
            SELECT  Vchcode, Vchtype, dlyorder, d.PtypeId, Blockno, Prodate, tax_total    
            ,FreeDom03,FreeDom01,FreeDom02,Qty=case when Qty>0 then '-'+Convert(varchar,Qty) when qty<0 then ABS(qty) else qty end,price=TaxPrice,comment   
            FROM    DlySale d    
            INNER JOIN #Prights p    
            ON      d.PtypeId = p.PTypeID    
            WHERE   Draft = 2    
                    AND ( @szPTypeID = '%'    
                          OR d.PtypeId LIKE @szPTypeID )    
            UNION ALL    
            SELECT  Vchcode, Vchtype, dlyorder, d.PtypeId, Blockno, Prodate, tax_total    
            ,FreeDom03='',FreeDom01='',FreeDom02='',Qty=0,price='',comment=''   
            FROM    DlyBuy d    
            INNER JOIN #Prights p    
            ON      d.PtypeId = p.PTypeID    
            WHERE   Draft = 2    
                    AND ( @szPTypeID = '%'    
                          OR d.PtypeId LIKE @szPTypeID )    
            UNION ALL    
            SELECT  Vchcode, Vchtype, dlyorder, d.PtypeId, Blockno, Prodate, tax_total   
            ,FreeDom03='',FreeDom01='',FreeDom02='',Qty=0,price='',comment=''   
            FROM    DlyOther d    
            INNER JOIN #Prights p    
            ON      d.PtypeId = p.PTypeID    
            WHERE   Draft = 2    
                    AND ( @szPTypeID = '%'    
                          OR d.PtypeId LIKE @szPTypeID ) ) AS a    
  WHERE   a.PtypeId <> ''    
  OPTION  ( RECOMPILE )    
  SELECT  a.*, ISNULL(t.Name, '') AS VchName    
  INTO    #BillNdxRights    
  FROM    ( SELECT  Vchcode, VchType, d.btypeid, d.BTypeID2, d.SettleBtypeId, etypeid, d.projectid, DATE, summary,    
                    NUMBER, d.mtypeid    
            FROM    Dlyndx d    
            INNER JOIN #Brights b3    
            ON      d.SettleBtypeId = b3.BtypeId    
            INNER JOIN #Drights de    
            ON      d.projectid = de.DTypeID    
            WHERE   draft = 2    
                    AND CASE WHEN VchType > 10000 THEN VchType / 10000    
                             ELSE VchType    
                        END IN ( 11, 26, 45 )    
                    AND d.DATE BETWEEN @szBeginDate AND @szEndDate    
                    AND ( @szBTypeID = '%'    
                          OR d.SettleBtypeId LIKE @szBTypeID )    
            UNION ALL    
            SELECT  Vchcode, VchType, d.btypeid, d.BTypeID2, d.SettleBtypeId, etypeid, d.projectid, DATE, summary,    
                    NUMBER, d.mtypeid    
            FROM    Dlyndx d    
            INNER JOIN #Brights b1    
            ON      d.btypeid = b1.BtypeId    
            INNER JOIN #Drights de    
            ON      d.projectid = de.DTypeID    
            WHERE   draft = 2    
                    AND CASE WHEN VchType > 10000 THEN VchType / 10000    
                             ELSE VchType    
                        END NOT IN ( 11, 26, 45 )    
                    AND d.DATE BETWEEN @szBeginDate AND @szEndDate    
                    AND ( @szBTypeID = '%'    
                          OR d.btypeid LIKE @szBTypeID )    
            UNION ALL    
            SELECT  Vchcode, VchType, d.Btypeid, '', '', Etypeid, d.Projectid, DATE, Summary, NUMBER, d.mtypeid    
            FROM    DlyNdxARAPIni d    
            INNER JOIN #Brights b1    
            ON      d.Btypeid = b1.BtypeId    
            INNER JOIN #Drights de    
            ON      d.Projectid = de.DTypeID    
            WHERE   d.DATE BETWEEN @szBeginDate AND @szEndDate    
                    AND ( @szBTypeID = '%'    
                          OR d.Btypeid LIKE @szBTypeID ) ) AS a    
  LEFT JOIN dbo.GetVchtype() t    
  ON      a.VchType = t.Vchtype    
  OPTION  ( RECOMPILE )    
  SELECT  ndx.Vchcode, ndx.VchType, ndx.VchName, ndx.DATE, ndx.NUMBER, ndx.summary,    
          CASE WHEN CASE WHEN ndx.VchType > 10000 THEN ndx.VchType / 10000    
                         ELSE ndx.VchType    
                    END IN ( 11, 26, 45 ) THEN ndx.SettleBtypeId    
               ELSE ndx.btypeid    
          END AS BCtypeId, CASE WHEN CASE WHEN ndx.VchType > 10000 THEN ndx.VchType / 10000    
                                          ELSE ndx.VchType    
                                     END IN ( 11, 26, 45 ) THEN ndx.btypeid    
                                ELSE ''    
                           END AS BtypeId, ndx.etypeid, ndx.projectid, dly.PtypeId, dly.Blockno, dly.Prodate,    
          dly.Dlyorder, ndx.mtypeid,dly.FreeDom03,dly.FreeDom01,dly.FreeDom02,dly.Qty,dly.price,dly.comment    
  INTO    #DlyPtypes    
  FROM    #BillPtypeDly dly    
  INNER JOIN #BillNdxRights ndx    
  ON      dly.Vchcode = ndx.Vchcode    
          AND dly.Vchtype = ndx.VchType    
  SELECT  Vchcode, Vchtype, Dlyorder, Total, IniTotal + SelfTotal + CashTotal + SettleTotal + CancelTotal AS AllTotal,    
          Total - IniTotal - SelfTotal - CashTotal - SettleTotal - CancelTotal AS NoTotal   
  INTO    #ArSettle    
  FROM    ARSettle    
  WHERE   @showOver = 0    
          OR ( @showOver = 1    
               AND ( ( Total > 0    
                       AND Total > IniTotal + SelfTotal + CashTotal + SettleTotal + CancelTotal )    
                     OR ( Total < 0    
                          AND Total < IniTotal + SelfTotal + CashTotal + SettleTotal + CancelTotal ) ) )    
  SELECT  dly.VchName AS vchtypename, ar.Vchcode, ar.Vchtype, dly.DATE, dly.NUMBER, dly.summary, dly.BCtypeId,    
          dly.BtypeId, dly.etypeid, dly.projectid AS dtypeid, dly.PtypeId, dly.Blockno, dly.Prodate, dly.Dlyorder,    
          ar.Total, ar.AllTotal, ar.NoTotal, dly.mtypeid --金额   
    ,dly.FreeDom03,dly.FreeDom01,dly.FreeDom02,dly.Qty,dly.price,dly.comment  
  INTO    #TempPage    
  FROM    #ArSettle ar    
  INNER JOIN #DlyPtypes dly    
  ON      dly.Vchcode = ar.Vchcode    
          AND dly.VchType = ar.Vchtype    
          AND dly.Dlyorder = ar.Dlyorder  
  and (case when @showType=0 then ABS(ar.Total) when @showType=1  then ABS(ar.NoTotal) when @showType=2 then ABS(ar.alltotal) end >'0' ) 
  IF @IsPaging = 1    
    EXEC [P_XIWA_ToPage] '#TempPage', @PageSize, @PageIndex, @PageFilter, @PageTotal OUTPUT, 'date, vchcode',    
      'total;alltotal;nototal'    
  ELSE    
    SELECT  *    
    FROM    #TempPage    
    ORDER BY DATE, Vchcode    
  DROP TABLE #TempPage     
  DROP TABLE #Brights    
  DROP TABLE #Drights    
  DROP TABLE #Prights    
  DROP TABLE #BillPtypeDly    
  DROP TABLE #BillNdxRights    
  DROP TABLE #ArSettle    
  DROP TABLE #DlyPtypes    
END    