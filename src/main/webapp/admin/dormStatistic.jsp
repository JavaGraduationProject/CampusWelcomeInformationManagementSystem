<%--
  Created by IntelliJ IDEA.
  User: Peroy
  Date: 2021/1/16
  Time: 16:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>宿舍分配统计</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="../commons/jslib/hplus/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="../commons/jslib/hplus/css/font-awesome.min.css?v=4.4.0"
          rel="stylesheet">
    <link href="../commons/jslib/hplus/css/animate.min.css"
          rel="stylesheet">
    <link href="../commons/jslib/hplus/css/style.min.css?v=4.0.0"
          rel="stylesheet">
    <link href="../commons/jslib/hplus/css/plugins/bootstrap-table/bootstrap-table.min.css"
          rel="stylesheet">

    <!-- Sweet Alert -->
    <link href="../commons/jslib/hplus/css/plugins/sweetalert/sweetalert.css"
          rel="stylesheet">
    <!-- Sweet Alert -->
    <link href="../commons/css/qy-style.css" rel="stylesheet">

    <link href="../commons/jslib/hplus/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css"
          rel="stylesheet">
    <script src="../commons/jslib/hplus/js/jquery.min.js?v=2.1.4"></script>
    <script src="../commons/jslib/hplus/js/jquery-ui-1.10.4.min.js"></script>
    <script
            src="../commons/jslib/hplus/js/plugins/validate/jquery.validate.min.js"></script>
    <script
            src="../commons/jslib/hplus/js/plugins/validate/messages_zh.min.js"></script>

    <script type="text/javascript" src="../commons/jslib/jquery-form.js"></script>

    <script src="../commons/jslib/hplus/js/bootstrap.min.js?v=3.3.5"></script>
    <script src="../commons/jslib/hplus/js/content.min.js?v=1.0.0"></script>

    <!-- Sweet Alert -->
    <script type="text/javascript"
            src="../commons/jslib/hplus/js/plugins/sweetalert/sweetalert.min.js"></script>
    <!-- Sweet Alert -->
    <script src="../commons/jslib/hplus/js/plugins/iCheck/icheck.min.js"></script>
    <script src="../commons/jslib/CommonValue.js"></script>
    <script src="../commons/jslib/hplus/js/plugins/prettyfile/bootstrap-prettyfile.js"></script>
    <!--数据导出相关-->
    <script src="../commons/tableExport.jquery.plugin/tableExport.js"></script>
    <script src="../commons/tableExport.jquery.plugin/libs/FileSaver/FileSaver.min.js"></script>
    <script src="../commons/tableExport.jquery.plugin/libs/jsPDF/jspdf.min.js"></script>
    <script src="../commons/tableExport.jquery.plugin/libs/jsPDF-AutoTable/jspdf.plugin.autotable.js"></script>
    <script src="../commons/tableExport.jquery.plugin/libs/js-xlsx/xlsx.core.min.js"></script>
    <script src="../commons/jslib/hplus/js/plugins/bootstrap-table/dist/bootstrap-table.min.js"></script>
    <script src="../commons/jslib/hplus/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"
            type="text/javascript"></script>
    <script src="../commons/jslib/hplus/js/plugins/bootstrap-table/dist/extensions/export/bootstrap-table-export.min.js"></script>
    <!--echarts-->
<%--    <script type="text/javascript" src="../commons/echarts.js"></script>--%>
<%--    <script type="text/javascript" src="../commons/macarons.js"></script>--%>
    <script type="text/javascript" src="../commons/jslib/hplus/js/plugins/echarts/echarts-all.js"></script>
</head>
<body class="gray-bg">
    <div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-12">
            <p>预留位置,待开发</p>
        </div>
    </div>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <!--宿舍分配情况可视化-->
        <div class="col-sm-12">
            <div class="ibox-content">
                <div class="echarts" id="echarts_dorm"></div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox-content table-responsive">
                <table id="table" class="table"data-click-to-select="true">
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        //宿舍分配情况
        var myChart=echarts.init(document.getElementById('echarts_dorm'));
       myChart.showLoading();//显示loading动画
        var names=[];   //(存放x轴坐标值)
        var nums=[];    //(存放Y坐标值)
        $.ajax({
           url:'/ysms/dorm/dormDistribution',
            type:'post',
            data:{},
            cache:false,
            async:false,
            dataType:'json',
            success:function (result) {
               for (var i in result){
                   names.push(result[i].id);
                   nums.push(result[i].alreadyNumber);
               }
               myChart.hideLoading();   //隐藏加载动画
                myChart.setOption({ //加载数据图表
                    title:{
                        text:'宿舍分配情况'
                    },
                    tooltip:{
                        show:true
                    },
                    legend:{
                        data:['已住人数']
                    },
                    toolbox: {                  //工具栏
                        show: true,               //显示工具栏组件
                        feature: {                //各工具配置项
                            mark: {
                                show: true
                            },
                            dataView: {
                                show: true,           //显示该工具
                                readOnly: false       //是否显示不可编辑(只读)
                            },
                            magicType: {            //动态类型切换
                                show: true,           //是否显示该工具
                                type: ['line', 'bar'] //启用的动态类型
                            },
                            restore: {              //配置项还原
                                show: true            //是否显示该工具
                            },
                            saveAsImage: {          //保存为图片
                                show: true            //是否显示该工具
                            }
                        }
                    },
                    xAxis:{
                        type:'category',
                        data:names
                    },
                    yAxis:{
                        type:'value',
                        axisLabel : {
                            formatter: '{value}人'
                        }
                    },
                    dataZoom : {
                            type:'slider',
                            show : true,
                            realtime: true,
                            start : 10,
                            end : 20
                        },
                    series:[{
                        name:'已住人数',
                        type:'line',
                        data:nums,
                        itemStyle: {
                            normal: {
                                label: {
                                    show: true,  //开启显示
                                    position: 'top',  //在上方显示
                                    textStyle: {  //数值样式
                                        color: 'black',
                                        fontSize: 16
                                    }
                                }
                            }
                        }
                    }]
                });
                $(window).resize(myChart.resize);
            }
        });

        var $table=$('#table');
        $table.bootstrapTable({
            url:'/ysms/dorm/getUnAllocation',
            dataType:'json',
            method:'post',
            contentType: "application/x-www-form-urlencoded;charset=UTF-8",//发送到服务器的数据编码类型
            cache:false,        //禁用AJAX数据缓存
            sidePagination: 'server',   //服务端处理分页
            pagination:true,    //是否显示分页
            pageSize:8,         //设置每页的记录行数
            pageList: [8,16,32,64,128,256],  //可供选择的每页的行数
            pageNumber:1,       //设置首页页码
            singleSelect:false, //设置是否单选
            checkboxHeader: true,
            showRefresh:true,   //是否显示刷新按钮
            showToggle:true,    //是否显示详细视图和列表视图的切换按钮
            showColumns:true,   //选择要显示的列
            striped: true,      //是否显示行间隔色
            clickToSelect:true, //是否启用点击选中行
            queryParamsType:"undefined",    //设置参数格式
            queryParams:function queryParams(params) {  //设置查询参数page和rows
                //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                var param={
                    page:params.pageNumber, //首页页码
                    rows:params.pageSize,  //每页的记录行数
                };
                return param;
            },
            columns:[{
                checkbox:true
            },{
                title:'宿舍编号',
                field:'id',
                valign:'middle'
            },{
                title:'男/女宿舍',
                field:'sex',
                valign:'middle'
            },{
                title:'已住人数',
                field:'alreadyNumber',
                valign:'middle'
            },{
                title:'可住人数',
                field:'allNumber',
                valign:'middle'
            },{
                title:'是否住满',
                field:'status',
                valign:'middle'
            }]
        });

    });
</script>
</body>
</html>
