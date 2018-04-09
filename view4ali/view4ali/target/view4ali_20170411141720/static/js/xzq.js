var xzq = {};
xzq['320100'] ="南京";xzq['3201'] ="南京";
xzq['320200'] ="无锡";xzq['3202'] ="无锡";
xzq['320300'] ="徐州";xzq['3203'] ="徐州";
xzq['320400'] ="常州";xzq['3204'] ="常州";
xzq['320500'] ="苏州";xzq['3205'] ="苏州";
xzq['320600'] ="南通";xzq['3206'] ="南通";
xzq['320700'] ="连云港";xzq['3207'] ="连云港";
xzq['320800'] ="淮安";xzq['3208'] ="淮安";
xzq['320900'] ="盐城";xzq['3209'] ="盐城";
xzq['321000'] ="扬州";xzq['3210'] ="扬州";
xzq['321100'] ="镇江";xzq['3211'] ="镇江";
xzq['321200'] ="泰州";xzq['3212'] ="泰州";
xzq['321300'] ="宿迁";xzq['3213'] ="宿迁";

function converToXzqByDm(dm){
    if (xzq[dm]) {
        return xzq[dm];
    }else if (dm.length>4 && xzq[dm.substr(0,4)]) {
        return xzq[dm.substr(0,4)]
    }else{
        return "其他";
    }
}