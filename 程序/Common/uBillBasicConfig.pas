unit uBillBasicConfig;

interface

uses SysUtils, xwbasicinfoclassdefine_c, xwVchCalcClass, XWComponentType,
     xwGtypedefine, xwCalcFieldsDefine, Generics.Collections;

const
  SALE_VCHTYPE = 11;                    //销售单
  SALEBACK_VCHTYPE = 45;                //销售退货单
  BUY_VCHTYPE = 34;                     //进货
  BUYBACK_VCHTYPE = 6;                  //进货退货单

  PRICE_ALLOT_VCHTYPE = 21;             //调拨单
  CHANGE_PRICE_VCHTYPE = 57;            //调价单

  LOSE_VCHTYPE = 9;                     //报损
  GET_VCHTYPE = 14;                     //报溢单
  INLIB_VCHTYPE = 140;                  //入库单
  OUTLIB_VCHTYPE = 141;                 //出库核算单

  EXPENSE_VCHTYPE = 36;                 //其他付款业务
  OTHER_INCOME_VCHTYPE = 93;            //其它收款业务
  MONEY_CHANGE_VCHTYPE = 77;            //银行存取款
  GATHERING_VCHTYPE = 4;                //收款单
  PAYMENT_VCHTYPE = 66;                 //付款单

  COMMISSION_VCHTYPE = 25;              //委托发货单
  COMMISSION_JS_VCHTYPE = 26;           //委托结算
  COMMISSION_BACK_VCHTYPE = 30;         //委托退货单
  COMMISSION_PRICE_VCHTYPE = 50;        //委托调价

  BUY_FEE_VCHTYPE = 37;                 //进货费用
  BUY_EXPENSESALLOT_VCHTYPE = 38;       //进货费用分配

  INVOICE_SALEBILL = 81;                //销售开票
  INVOICE_BUYBILL  = 82;                //进货开票

  WLHX_VCHTYPE = 83;                    //往来核销

  PRODUCE_VCHTYPE = 16;                 //组装拆分单
  SPLITEXPENSEALLOT_VCHTYPE = 19;       //组装拆分费用单

  Buy_Requisition_VchType = 142;        //请购单
  Sale_Offer_VchType = 143;             //销售报价单
  LOAN_VCHTYPE = 144;                   //借款单
  EXPENSEWIPEOUT_VCHTYPE = 145;         //费用报销单

  BUY_SEND_CHECK  = 146;                //送检单
  BUY_QMCHECK = 147;                    //进货检验单

  COUNT_VCHTYPE = 125;                  //凭证单
  ORDER_BUY_VCHTYPE = 150;              //进货订单
  ORDER_SALE_VCHTYPE = 151;             //销售订单

  INSTOCK_VALUE_VCHTYPE = 161;          //暂估入库单

  FACTSTOCK_INLIB_VCHTYPE = 46;         //仓库入库单
  FACTSTOCK_OUTLIB_VCHTYPE = 47;        //仓库出库单
  FACTSTOCK_ALLOT_VCHTYPE = 48;         //仓库调拨单

  PRODUCE_PLAN_VCHTYPE = 170;           //生产计划单
  PRODUCE_ROLE_VCHTYPE = 171;           //生产任务单
  PRODUCE_DRAW_VCHTYPE = 172;           //领料单
  PRODUCE_DRAW_BACK_VCHTYPE = 173;      //退料单
  PRODUCE_CHECKACCEPT_VCHTYPE = 174;    //完工验收单
  PRODUCE_EXPENSESALLOT_VCHTYPE = 175;  //费用分配单
  PRODUCE_LOSE_VCHTYPE = 176;           //生产报损单
  PRODUCE_GET_VCHTYPE = 177;            //生产报溢单
  PRODUCE_CHANGE_PRICE_VCHTYPE = 178;   //生产调价单

  CONSIGN_PLAN_VCHTYPE = 180;           //委外加工计划单
  CONSIGN_TASK_VCHTYPE = 181;           //委外加工单　
  CONSIGN_DRAW_VCHTYPE = 182;           //委外领料单
  CONSIGN_DRAW_BACK_VCHTYPE = 183;      //委外退料单
  CONSIGN_CHECKACCEPT_VCHTYPE = 184;    //委外完工验收单
  CONSIGN_PROCESS_FEE_VCHTYPE = 185;    //委外加工费用单
  CONSIGN_SETTLE_VCHTYPE = 186;         //委外费用结算单
  CONSIGN_EXPENSESALLOT_VCHTYPE = 187;  //委外费用分配单

  WORK_ORDER_VCHTYPE = 190;             //派工单
  WORK_HAND_OVER_VCHTYPE = 191;         //工序交接单
  WORK_TICKET_VCHTYPE = 192;            //工票

  Ini_GoodsStock_VCHTYPE = 201;         //库存期初结存单
  Ini_FactStock_VCHTYPE = 202;          //实物仓库期初结存单
  Ini_Commission_VCHTYPE = 203;         //委托期初结存单
  Ini_Settle_VCHTYPE = 204;             //期初未结算单
  Ini_ProduceStock_VchType = 206;       //车间材料期初结存单
  Ini_ConsignStock_VchType = 207;       //委外材料期初结存单

  SIMPLE_CONSIGN_TASK_VCHTYPE = 211;           //简单委外加工单　
  SIMPLE_CONSIGN_DRAW_VCHTYPE = 212;           //简单委外领料单
  SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE = 213;      //简单委外退料单
  SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE = 214;    //简单委外完工验收单

type
  TVchTypes = set of 1..255;

const
  PGoodsVchTypes: TVchTypes = [
    BUY_VCHTYPE,
    SALE_VCHTYPE,
    BUYBACK_VCHTYPE,
    SALEBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_BACK_VCHTYPE
  ];

  //====支持多仓库出入库的单据=============
  CanUseMultiStockVchTypes : TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    PRODUCE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Settle_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE
  ];

  //====可以使用单金额的单据============
  CanUseQtyZeroVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE
  ];

  PNoVoucherVchTypes: TVchTypes = [
    COMMISSION_PRICE_VCHTYPE,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
//    PRICE_ALLOT_VCHTYPE, //Add by zle @2005-08-23 调拨单不生成凭证。
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  PJSVchTypes: TVchTypes = [
    PAYMENT_VCHTYPE,
    GATHERING_VCHTYPE
  ];

  //不能被红冲的单据
  NonRedVchtypes: TVchTypes =[
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    BUY_FEE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,  //Add by zle @2005-05-20不能红冲的单据增加暂估入库单
    CHANGE_PRICE_VCHTYPE,   //Add by zle @2005-05-27不能红冲的单据增加调价单
    WLHX_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_PLAN_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    PRODUCE_EXPENSESALLOT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    PRODUCE_CHANGE_PRICE_VCHTYPE,
    CONSIGN_PLAN_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    CONSIGN_PROCESS_FEE_VCHTYPE,
    CONSIGN_SETTLE_VCHTYPE,
    CONSIGN_EXPENSESALLOT_VCHTYPE,
    LOAN_VCHTYPE,           //Add by wyli 2011-3-1 不能红冲的单据增加借款单和费用报销单
    EXPENSEWIPEOUT_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    Buy_Requisition_VchType, //请购单 lyh
    Sale_Offer_VchType,  //销售报价单 lyh
    SIMPLE_CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  CAN_LOADFROMOTHER_VCHTYPES: TVchTypes = [
    ORDER_BUY_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    PRODUCE_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  ORDER_VCHTYPES: TVchTypes = [
    ORDER_SALE_VCHTYPE,
    ORDER_BUY_VCHTYPE
  ];

  DONT_SAVE_TO_DRAFT_VCHTYPES: TVchTypes = [// 不能存为草稿的单据
    CHANGE_PRICE_VCHTYPE, //调价单 Add By Fhying 2004-07-16.
    INSTOCK_VALUE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WLHX_VCHTYPE,
    CONSIGN_EXPENSESALLOT_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    PRODUCE_CHANGE_PRICE_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  NonVoucherVchtypes: TVchTypes = [  //加权平均法下平时不生成凭证的单据
    LOSE_VCHTYPE,
    COMMISSION_VCHTYPE,
    PRODUCE_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE
  ];

  RightModifyPriceVchtypes: TVchtypes = [
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,

    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,

    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,

    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE  //代销退货单   ]
  ];

  DynamicPriceBitVchtypes: TVchtypes = [
    ORDER_BUY_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    Buy_Requisition_VchType,
    Sale_Offer_VchType,
    PRODUCE_ROLE_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_TASK_VCHTYPE
  ];

  INVOICE_VCHTYPES: TVchtypes = [INVOICE_SALEBILL, INVOICE_BUYBILL];

  PRODUCEOTHER_VCHTYPES: TVchTypes = [
    PRODUCE_PLAN_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    CONSIGN_PLAN_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_TASK_VCHTYPE
  ];

  //多仓库
  MultiKTypeVchTypes: TVchTypes = [
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    PRODUCE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Settle_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE
  ];

  //金额权限的单据
  CostViewVchTypes: TVchTypes = [
    ORDER_BUY_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    PRODUCE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //单金额单据
  OnlyTotalVchTypes: TVchTypes = [
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType
  ];

  //不显示核算科目的单据
  NonShowAsstAcntVchtypes: TVchTypes = [
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    BUY_FEE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_PLAN_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    PRODUCE_EXPENSESALLOT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    CONSIGN_PLAN_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    CONSIGN_PROCESS_FEE_VCHTYPE,
    CONSIGN_SETTLE_VCHTYPE,
    CONSIGN_EXPENSESALLOT_VCHTYPE,
    EXPENSEWIPEOUT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    Buy_Requisition_VchType,
    Sale_Offer_VchType
  ];

  //不显示单据查找的单据
  NonShowLoadBillVchTypes: TVchTypes = [
    BUY_FEE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WLHX_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_PLAN_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    PRODUCE_EXPENSESALLOT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    CONSIGN_PLAN_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    CONSIGN_PROCESS_FEE_VCHTYPE,
    CONSIGN_SETTLE_VCHTYPE,
    CONSIGN_EXPENSESALLOT_VCHTYPE,
    LOAN_VCHTYPE,
    EXPENSEWIPEOUT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  //自动生成摘要
  AutoBuildSummaryVchTypes: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    CHANGE_PRICE_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    EXPENSE_VCHTYPE,
    OTHER_INCOME_VCHTYPE,
    MONEY_CHANGE_VCHTYPE,
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    PRODUCE_VCHTYPE,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    PRODUCE_CHANGE_PRICE_VCHTYPE
  ];

  //期初单据
  IniVchTypes: TVchTypes = [
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType
  ];

  //无审核功能
  AllCanNotAuditVchTypes: TVchTypes = [
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WORK_HAND_OVER_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  //多表格或表格对应多moudleno的单据
  AllMoreModuleNoVchTypes: TVchTypes = [
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    PRODUCE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    WLHX_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    PRODUCE_EXPENSESALLOT_VCHTYPE,

    PRODUCE_ROLE_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_QMCHECK
  ];

  //明细主属性不是存货的单据
  AllNotMainPtypeVchTypes: TVchTypes = [
    EXPENSE_VCHTYPE,
    OTHER_INCOME_VCHTYPE,
    MONEY_CHANGE_VCHTYPE,
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    BUY_FEE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WLHX_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    PRODUCE_EXPENSESALLOT_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE
  ];

  //实物仓库单据
  FactStockVchTypes: TVchTypes = [
    Ini_FactStock_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE
  ];

  //需要控制仓库权限的单据
  AllBillCheckKrightsVchTypes: TVchTypes = [
    ORDER_BUY_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    CHANGE_PRICE_VCHTYPE,
    //////////////////////
    PRICE_ALLOT_VCHTYPE,
    PRODUCE_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Settle_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //需要控制往来单位权限的单据
  AllBillCheckBrightsVchTypes: TVchTypes = [
    ORDER_BUY_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    //////////////////////
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    WLHX_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    BUY_FEE_VCHTYPE,
    EXPENSE_VCHTYPE,
    OTHER_INCOME_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    /////////////////////
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    Sale_Offer_VchType,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,

    BUY_SEND_CHECK,
    BUY_QMCHECK

//    Ini_ConsignStock_VchType,

//    CONSIGN_PLAN_VCHTYPE,
//    CONSIGN_TASK_VCHTYPE,
//    CONSIGN_DRAW_VCHTYPE,
//    CONSIGN_DRAW_BACK_VCHTYPE,
//    CONSIGN_CHECKACCEPT_VCHTYPE,
//    CONSIGN_PROCESS_FEE_VCHTYPE,
//    CONSIGN_SETTLE_VCHTYPE,
//    CONSIGN_EXPENSESALLOT_VCHTYPE
  ];

  AllBillCheckDrightsVchTypes: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    CHANGE_PRICE_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    EXPENSE_VCHTYPE,
    OTHER_INCOME_VCHTYPE,
    MONEY_CHANGE_VCHTYPE,
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    BUY_FEE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WLHX_VCHTYPE,
    PRODUCE_VCHTYPE,
    Buy_Requisition_VchType,
    Sale_Offer_VchType,
    LOAN_VCHTYPE,
    EXPENSEWIPEOUT_VCHTYPE,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE,

    BUY_SEND_CHECK,
    BUY_QMCHECK

//生产委外不控制部门权限
//    PRODUCE_CHANGE_PRICE_VCHTYPE
  ];

  AllBillCheckPrightsVchTypes: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    CHANGE_PRICE_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    PRODUCE_VCHTYPE,
//    SPLITEXPENSEALLOT_VCHTYPE, //add by wli 组装拆分费用单
    Buy_Requisition_VchType,
    Sale_Offer_VchType,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,

    BUY_SEND_CHECK,
    BUY_QMCHECK

//生产委外不控制存货权限
//    Ini_ProduceStock_VchType,
//    Ini_ConsignStock_VchType,
//
//    PRODUCE_PLAN_VCHTYPE,
//    PRODUCE_ROLE_VCHTYPE,
//    PRODUCE_DRAW_VCHTYPE,
//    PRODUCE_DRAW_BACK_VCHTYPE,
//    PRODUCE_CHECKACCEPT_VCHTYPE,
//    PRODUCE_EXPENSESALLOT_VCHTYPE,
//    PRODUCE_LOSE_VCHTYPE,
//    PRODUCE_GET_VCHTYPE,
//    PRODUCE_CHANGE_PRICE_VCHTYPE,
//
//    CONSIGN_PLAN_VCHTYPE,
//    CONSIGN_TASK_VCHTYPE,
//    CONSIGN_DRAW_VCHTYPE,
//    CONSIGN_DRAW_BACK_VCHTYPE,
//    CONSIGN_CHECKACCEPT_VCHTYPE,
//    CONSIGN_EXPENSESALLOT_VCHTYPE,
//
//    WORK_ORDER_VCHTYPE,
//    WORK_HAND_OVER_VCHTYPE,
//    WORK_TICKET_VCHTYPE,
//
//    SIMPLE_CONSIGN_TASK_VCHTYPE,
//    SIMPLE_CONSIGN_DRAW_VCHTYPE,
//    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
//    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //自动填入经办人，部门的单据
  AllBillAutoFillInETypeDtypeVchTypes: TVchTypes = [
    ORDER_SALE_VCHTYPE,
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    GATHERING_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    Buy_Requisition_VchType,
    Sale_Offer_VchType
  ];

  //领料、退料
  DRAW_BACK_DRAW_VCHTYPES: TVchtypes = [
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE
  ];

  //查看车间库的单据
  AllSCGoodsVchTypes: TVchTypes = [
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    Ini_ProduceStock_VchType,
    PRODUCE_CHANGE_PRICE_VCHTYPE
  ];

  //查看委外库的单据
  AllWeiWaiGoodsVchTypes: TVchTypes = [
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //主表格显示气泡的单据
  AllMainGridShowPtypeInfoTip: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,

    PRICE_ALLOT_VCHTYPE,
//    CHANGE_PRICE_VCHTYPE,

    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,

    COMMISSION_VCHTYPE,
    PRODUCE_VCHTYPE,

    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,

    INSTOCK_VALUE_VCHTYPE,

    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //次表格显示气泡的单据
  AllOtherGridShowPtypeInfoTip: TVchTypes = [
    PRODUCE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  //不显示虚拟库存的单据
  AllNotShowVirtualGoodsVchType: TVchTypes = [
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    PRODUCE_LOSE_VCHTYPE,
    PRODUCE_GET_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  AllUserSerialNoVchType: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    PRODUCE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  AllMainGridUseSerialNoVchType: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    PRICE_ALLOT_VCHTYPE,
    LOSE_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    OUTLIB_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    PRODUCE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    FACTSTOCK_OUTLIB_VCHTYPE,
    FACTSTOCK_ALLOT_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  AllOtherGridUseSerialNoVchType: TVchTypes = [
    PRODUCE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE
  ];

  AllMainGridInSerialNoVchType: TVchTypes = [
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    GET_VCHTYPE,
    INLIB_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    FACTSTOCK_INLIB_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE
  ];

  AllOtherGridInSerialNoVvchType: TVchTypes = [
    PRODUCE_VCHTYPE
  ];

  AllNoDraftVchTypes: TVchTypes = [
    Ini_GoodsStock_VCHTYPE,
    Ini_FactStock_VCHTYPE,
    Ini_Commission_VCHTYPE,
    Ini_Settle_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  AllHasPrevBillVchtype: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    GATHERING_VCHTYPE,
    PAYMENT_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    COMMISSION_BACK_VCHTYPE,
    COMMISSION_PRICE_VCHTYPE,
    BUY_EXPENSESALLOT_VCHTYPE,
    INVOICE_SALEBILL,
    INVOICE_BUYBILL,
    WLHX_VCHTYPE,
    SPLITEXPENSEALLOT_VCHTYPE,
    EXPENSEWIPEOUT_VCHTYPE,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_DRAW_VCHTYPE,
    PRODUCE_DRAW_BACK_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    PRODUCE_EXPENSESALLOT_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    CONSIGN_DRAW_VCHTYPE,
    CONSIGN_DRAW_BACK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    CONSIGN_SETTLE_VCHTYPE,
    CONSIGN_EXPENSESALLOT_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    WORK_HAND_OVER_VCHTYPE,
    WORK_TICKET_VCHTYPE,
    Ini_ProduceStock_VchType,
    Ini_ConsignStock_VchType,
    SIMPLE_CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_VCHTYPE,
    SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  AllHasNextBillVchtype: TVchTypes = [
    SALE_VCHTYPE,
    SALEBACK_VCHTYPE,
    BUY_VCHTYPE,
    BUYBACK_VCHTYPE,
    INLIB_VCHTYPE,
    COMMISSION_VCHTYPE,
    COMMISSION_JS_VCHTYPE,
    BUY_FEE_VCHTYPE,
    PRODUCE_VCHTYPE,
    Buy_Requisition_VchType,
    Sale_Offer_VchType,
    LOAN_VCHTYPE,
    ORDER_BUY_VCHTYPE,
    ORDER_SALE_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE,
    WLHX_VCHTYPE,
    PRODUCE_PLAN_VCHTYPE,
    PRODUCE_ROLE_VCHTYPE,
    PRODUCE_CHECKACCEPT_VCHTYPE,
    CONSIGN_PLAN_VCHTYPE,
    CONSIGN_TASK_VCHTYPE,
    CONSIGN_CHECKACCEPT_VCHTYPE,
    CONSIGN_PROCESS_FEE_VCHTYPE,
    WORK_ORDER_VCHTYPE,
    Ini_Settle_VCHTYPE,
    SIMPLE_CONSIGN_TASK_VCHTYPE,
    SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE,
    BUY_SEND_CHECK,
    BUY_QMCHECK
  ];

  AllNeedLoadBuyOrderBills: TVchTypes = [
    BUY_VCHTYPE,
    INSTOCK_VALUE_VCHTYPE
  ];

  AllNeedLoadSaleOrderBills: TVchTypes = [
    SALE_VCHTYPE,
    COMMISSION_VCHTYPE
  ];

function GetBasicNumField(numField: TCMVchNumField): Boolean;
function GetFieldNotCanPrint(numField: TCMVchNumField): Boolean;
function GetVchBasicType(cmBasicType: TCMBasicType): TBasicType;

implementation

function GetBasicNumField(numField: TCMVchNumField): Boolean;
begin
  case numField of
    CMvcfAtype,
    CMvcfPtype,
    CMvcfBtype,
    CMvcfStype,
    CMvcfCtype,
    CMvcfWBtype,
    CMvcfEtype,
    CMvcfKtype,
    CMvcfDtype,
    CMvcfRtype,
    CMvcfTtype,
    CMvcfMtype,
    CMvcfZFtype,
    CMvcfZStype,
    CMvcfVchtype,
    CMvcfChktype,
    CMvcfBaltype,
    CMvcfOtype,
    CMvcfWtype,
    CMvcfWorkGroup,
    CMvcfEtype2,
    CMvcfWorkProcess,
    CMvcfWorkProcess2,
    CMvcfFtype,
    CMvcfGJType,
    CMvcfGJType2,
    CMvcfPSType,
    CMvcfPSType2,
    CMVcfCustom3,
    CMVcfCustom4:
      Result := True;
  else
    Result := False;
  end;
end;

function GetFieldNotCanPrint(numField: TCMVchNumField): Boolean;
begin
  case numField of
    CMvcfUnitRate1,
    CMvcfUnitRate2,
    CMvcfManageBlockNo,
    CMvcfSourceDlyOrder,
    CMvcfOrderCode,
    CMvcfUnit,
    CMvcfDlyOrder,
    CMvcfCostMode,
    CMvcfRec,
    CMvcfSourceVchType,
    CMvcfBaseUnit,
    CMvcfManageCustom1,
    CMvcfManageCustom2,
    CMvcfManageCustom3,
    CMvcfManageCustom4,
    CMvcfManagePosition,
    CMvcfManagePosition2:
      Result := True;
  else
    Result := False;
  end;
end;

function GetVchBasicType(cmBasicType: TCMBasicType): TBasicType;
begin
  case cmBasicType of
    CMbtAtype: Result := btAtype;
    CMbtPtype: Result := btPtype;
    CMbtDtype: Result := btDtype;
    CMbtGXType: Result := btGXtype;
    CMbtGXType1: Result := btGXtype;
    CMbtOperatingType: Result := btOtype;
    CMbtPSType: Result := btPStype;
    CMbtPSType2: Result := btPStype2;
  else
    Result := btNo;
  end;
end;

end.

