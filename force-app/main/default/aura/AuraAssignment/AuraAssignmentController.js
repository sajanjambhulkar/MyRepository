({
    showObject : function(component, event, helper) {
        var action = component.get("c.getObjectName");
        action.setCallback(this,function(response){
            var state= response.getState();
            if(state=="SUCCESS"){
                component.set("v.ObjectList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showField : function(component,helper,event) {
        var fld = component.find("Dropdown").get("v.value");
        component.set("v.ObjectName",fld);
        var action = component.get("c.getFieldName");
        action.setParams({ObjName:component.get("v.ObjectName")})
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                
                component.set("v.FieldList", response.getReturnValue());
                var array = component.get("v.FieldList");
                
                // console.log(typeof(array));
                let newArr=[];
                for( const[key,value] of Object.entries(array)){
                    newArr.push({label:value,value:value})
                }
                component.set("v.FieldOption",newArr);
                component.set("v.FieldList",[]);
                
                //console.log(newArr);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    FieldItem : function(component,helper,event){
        var name = component.find("item").get("v.value");
        var obj = component.get("v.ObjectName");
        console.log(typeof(name))
        console.log('name '+name)
        var array = Object.values(name);
        var flds = name.toString();
        
        component.set("v.QueryField", flds);  // it will have fields (not used to display at frontend)(passed in a getRecords apex method)
        
        component.set("v.myQueryField", 'SELECT '+flds+' FROM '+obj)  // (used only for displaying)
        
        let newArr=[];
        for( const[key,value] of Object.entries(array)){
            newArr.push({label:value,fieldName:value,type:'text'})
        }
        component.set("v.QueryFieldList", newArr);
        //console.log(newArr)
        //console.log(flds)
        
    },
    
    showRecord : function(component,helper,event){
        var action = component.get("c.getRecords");
        action.setParams({field:component.get("v.QueryField"),myobject:component.get("v.ObjectName")})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var myrecords = response.getReturnValue();
                component.set("v.Records", myrecords);
                
                
                console.log('Success --->');
                console.log(myrecords);
            }
        });
        $A.enqueueAction(action);
    }
})