package
{
   import flash.display.MovieClip;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.events.*;
   import com.meychi.ascrypt3.*;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.URLRequestMethod;
   import flash.net.URLLoaderDataFormat;
   import flash.filters.BlurFilter;
   import flash.text.TextFormat;
   import fl.events.ColorPickerEvent;
   import flash.filters.GlowFilter;
   import flash.display.StageDisplayState;
   import flash.net.navigateToURL;
   import fl.controls.RadioButtonGroup;
   import flash.utils.Timer;
   import flash.media.SoundTransform;
   import flash.net.NetStream;
   import fl.events.SliderEvent;
   import flash.net.SharedObject;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.media.H264VideoStreamSettings;
   import flash.media.Camera;
   import flash.media.Microphone;
   import flash.media.SoundCodec;
   import flash.media.H264Profile;
   import flash.media.H264Level;
   import flash.system.Security;
   import flash.system.SecurityPanel;
   import flash.display.Loader;
   import flash.net.SharedObjectFlushStatus;
   import flash.net.LocalConnection;
   import com.google.analytics.AnalyticsTracker;
   import flash.display.StageScaleMode;
   import com.google.analytics.GATracker;
   
   public class videoChat extends MovieClip
   {
      
      public function videoChat()
      {
         this.tracker = new GATracker(stage,"UA-6669334-3","AS3",false);
         this.bannedDevices = new Array();
         this.badCamsLoader = new URLLoader();
         this.camIgnoringMe = new Array("0.0.0.0");
         this.messages = [];
         this.UserInfo = {};
         this.ignoredPPL = new Array();
         this.flagMeArray = new Array();
         this.likeMeArray = new Array();
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         this.nc = new NetConnection();
         this.nc.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
         this.nc.client = this;
      }
      
      public var Application:MovieClip;
      
      public var alertW:MovieClip;
      
      public var bar_mc:MovieClip;
      
      public var enterRoomMC:MovieClip;
      
      public var login_mc:MovieClip;
      
      public var newRmc:MovieClip;
      
      public function loading(param1:Event) : void
      {
         var _loc2_:Number = this.stage.loaderInfo.bytesTotal;
         var _loc3_:Number = this.stage.loaderInfo.bytesLoaded;
         this.bar_mc.scaleX = _loc3_ / _loc2_;
         if(_loc2_ == _loc3_)
         {
            nextFrame();
            this.removeEventListener(Event.ENTER_FRAME,this.loading);
         }
      }
      
      public var sound1:String;
      
      public var myBell:Sound;
      
      public var xmlLoader:URLLoader;
      
      public function loaderMissing(param1:IOErrorEvent) : void
      {
         this.tracker.trackPageview("XML ERROR, IS  YOUR XML FILE THERE?");
         this.showAlerts("\nError XML\nTe recomendamos borrar el cache de tu navegador y recargar la pagina.");
         this.login_mc.login_btn.enabled = false;
         this.login_mc.visible = false;
      }
      
      public var xmlData:XML;
      
      public function loadXML(param1:Event) : void
      {
         this.xmlData = new XML(param1.target.data);
         this.fms_gateway = this.xmlData.chatConfig.serverURI.text();
         this.fms_country = this.xmlData.chatConfig.serverURI2.text();
         this.roomID = this.xmlData.chatConfig.roomID.text();
         this.flagPath = this.xmlData.chatConfig.flagPath.text();
         this.camQ = this.xmlData.chatConfig.cameraQ.text();
         this.camFPS = this.xmlData.chatConfig.cameraFPS.text();
         this.micQ = this.xmlData.chatConfig.micQ.text();
         this.maxUsers = this.xmlData.chatConfig.maxUsers.text();
         this.maxCamVtime = this.xmlData.chatConfig.maxCamVtime.text();
         this.flagMeLimit = this.xmlData.chatConfig.maxReports.text();
         this.sendCamTimeN = this.xmlData.chatConfig.sendCamTimeN.text();
         this.freeCamTimeN = this.xmlData.chatConfig.freeCamTimeN.text();
         this.sound1 = this.xmlData.chatConfig.pvSound.text();
         this.myBell.load(new URLRequest(this.sound1));
         this.lobbyID = this.roomID;
      }
      
      public var xmlFile;
      
      public var url:String;
      
      public function sendRealIP(param1:String) : void
      {
         var recibir:URLLoader = null;
         var Respuesta:Function = null;
         var HayError:Function = null;
         var realIP:String = param1;
         Respuesta = function(param1:Event):*
         {
            changingRoom = true;
            myCountry = recibir.data.replace(new RegExp("^\\s+|\\s+$","g"),"");
            if(myCountry.length > 25)
            {
               myCountry = "Unknown";
            }
            myCountry = "Lugano";
            tracker.trackPageview("COUNTRY FROM PHP: " + myCountry);
            nc.close();
            countryConn = false;
            connectApp();
            tracker.trackPageview("Set Real Country: " + myCountry);
         };
         HayError = function(param1:IOErrorEvent):void
         {
         };
         var enviar:URLRequest = new URLRequest(this.url);
         recibir = new URLLoader();
         var variables:URLVariables = new URLVariables();
         variables.ip = realIP;
         enviar.method = URLRequestMethod.POST;
         enviar.data = variables;
         recibir.dataFormat = URLLoaderDataFormat.TEXT;
         recibir.addEventListener(Event.COMPLETE,Respuesta);
         recibir.addEventListener(IOErrorEvent.IO_ERROR,HayError);
         recibir.load(enviar);
      }
      
      public var bf:BlurFilter;
      
      public var myColor:String;
      
      public var myColorX:String;
      
      public var fmt:TextFormat;
      
      public var fmtRoomList:TextFormat;
      
      public var formatMsg:TextFormat;
      
      public var formatRMsg:TextFormat;
      
      public var formatRMsg2:TextFormat;
      
      public var formatPVMsg:TextFormat;
      
      public var loginFormat:TextFormat;
      
      public var loginFormat2:TextFormat;
      
      public var startCamFormat:TextFormat;
      
      public var likesCam1Format:TextFormat;
      
      public var optionsFormat:TextFormat;
      
      public function doBold(param1:MouseEvent) : void
      {
         var _loc2_:* = "<b><font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Solamente usuarios <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrados</a></u></font> pueden usar esta opción.</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
      }
      
      public function doUnderline(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("underliFontClicked");
         var _loc2_:* = "<font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Solamente usuarios <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrados</a></u></font> pueden usar esta opción.</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
      }
      
      public function doItalic(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("ItalicFontClicked");
         var _loc2_:* = "<font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Solamente usuarios <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>registrados</a></u></font> pueden usar esta opción.</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
      }
      
      public function changeHandler(param1:ColorPickerEvent) : void
      {
         this.formatMsg.color = "0x" + param1.target.hexValue;
         this.myColor = "#" + param1.target.hexValue;
         this.myColorX = "0x" + param1.target.hexValue;
         this.Application.msg.setStyle("textFormat",this.formatMsg);
         this.tracker.trackPageview("FONT COLOR: " + this.myColor);
         this.local_so.data.myColor = this.myColorX;
      }
      
      public function changeFontSize(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("SizeFontClicked");
         var _loc2_:* = "<font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Solamente usuarios <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>registrados</a></u></font> pueden usar esta opción.</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
      }
      
      public function changeFont(param1:Event) : void
      {
         this.tracker.trackPageview("fontSelectedClicked");
         var _loc2_:* = "<font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Solamente usuarios <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrados</a></u></font> pueden usar esta opción.</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
         this.Application.fontSel.visible = false;
      }
      
      public function showFonts(param1:MouseEvent) : void
      {
         this.Application.fontSel.visible = true;
      }
      
      public var textFilter:GlowFilter;
      
      public function cierraCam(param1:MouseEvent) : void
      {
         this.closecam1();
      }
      
      public function sortPeople(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("SORT_BUTTON_CLICKED");
         if(this.listStatus == "label")
         {
            this.listStatus = "streaming";
         }
         else if(this.listStatus == "streaming")
         {
            this.listStatus = "label";
         }
         
      }
      
      public function goFullScreen() : void
      {
         if(stage.displayState == StageDisplayState.NORMAL)
         {
            stage.displayState = StageDisplayState.FULL_SCREEN;
         }
         else
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      public function regCLickURL(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("RegLink Register Button Clicked");
         var _loc2_:URLRequest = new URLRequest("http://www.chatvideo.es/reg.html");
         navigateToURL(_loc2_,"_parent");
      }
      
      public function closeCLick(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("Close RegLink Clicked");
         this.Application.bigRegister.visible = false;
      }
      
      public function _handleClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         this.tracker.trackPageview("fullScreen Clicked");
         if(this.isVip == false)
         {
            _loc2_ = "<font face=\'Tahoma\' size=\'13\' color=\'#FF0000\'>Debes ser usuario <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrado</a></u></font> para ver pantalla completa.</font>";
            this.messages.push({"chatMsg":_loc2_});
            this.displayMessages();
            return;
         }
         this.goFullScreen();
      }
      
      public var fontSelFormat:TextFormat;
      
      public function showOptionsPanel(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("Opciones_Clicked");
         this.Application.optionsMC.visible = true;
      }
      
      public function closeOptionsPanel(param1:MouseEvent) : void
      {
         this.Application.optionsMC.visible = false;
      }
      
      public function setFontTypeSO() : void
      {
         this.local_so.data.myFontType = this.formatMsg.font;
         this.local_so.data.myColor = this.formatMsg.color;
         this.local_so.data.myFontBold = this.formatMsg.bold;
         this.local_so.data.myFontItalic = this.formatMsg.italic;
      }
      
      public var genderGroup:RadioButtonGroup;
      
      public function announceCurrentGroup(param1:MouseEvent) : void
      {
         this.myGender = param1.target.value;
      }
      
      public function loginUser(param1:MouseEvent) : void
      {
         this.login_mc.server_msg.visible = false;
         this.login_mc.server_msg.text = "";
         if(this.login_mc.login_name.text == "" || this.login_mc.login_name.text == "undefined")
         {
            this.showAlerts("\n\nPor favor escribe tu nombre\n\n ");
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Por favor escribe tu nombre";
            return;
         }
         if(this.login_mc.login_name.text == "Administrador" || this.login_mc.login_name.text == "ADMINISTRADOR")
         {
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Nombre en Uso";
            return;
         }
         if(this.login_mc.login_name.text == "Admin" || this.login_mc.login_name.text == "ADMIN")
         {
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Nombre en Uso";
            this.tracker.trackPageview("Name_in_Use");
            return;
         }
         if(this.login_mc.login_name.text.length < 4)
         {
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Nombre muy corto, intenta nuevamente.";
            this.tracker.trackPageview("Name Too Short");
            return;
         }
         if(this.myGender == "")
         {
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Chico, Chica o Pareja?";
            return;
         }
         if(this.login_mc.age_box.selectedItem.data == "no")
         {
            this.login_mc.server_msg.visible = true;
            this.login_mc.server_msg.text = "Edad?";
            this.tracker.trackPageview("Age Missing @ Login");
            return;
         }
         this.login_mc.server_msg.text = "Conectando ...";
         this.login_mc.server_msg.visible = true;
         this.login_mc.login_btn.enabled = false;
         this.login_mc.conn_anim.visible = true;
         this.myAge = this.login_mc.age_box.selectedItem.label;
         this.myName = this.login_mc.login_name.text;
         this.Application.myCamMC.myName.text = this.myName;
         this.Application.myRedNick.text = this.myName;
         this.Application.myCamMC.maleIconTop.visible = false;
         this.Application.myCamMC.femaleIconTop.visible = false;
         this.Application.myCamMC.coupleIconTop.visible = false;
         if(this.myGender == "male")
         {
            this.Application.myCamMC.maleIconTop.visible = true;
         }
         if(this.myGender == "female")
         {
            this.Application.myCamMC.femaleIconTop.visible = true;
         }
         if(this.myGender == "couple" && this.isVip == true)
         {
            this.Application.myCamMC.coupleIconTop.visible = true;
         }
         this.login_mc.server_msg.visible = false;
         this.connectCountry();
         this.storeLocalSO();
         this.Eql9844kmgldiroURrX998q12Vgm = this.myName;
         this.minutesToGo = this.myName;
         this.timeWatched = this.myAge;
         this.minutesToGo2 = this.myGender;
      }
      
      public var reportedPPL;
      
      public var rijndael_key5:String;
      
      public function reportUser(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam1.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'><b>* " + _loc2_ + " ha sido reportad@ como inapropiad@</font></b>";
         this.messages.push({"chatMsg":_loc3_});
         this.displayMessages();
         this.Application.myTooltip2.hide();
         this.reportedPPL.push(_loc2_);
         this.tracker.trackPageview("User Flagged");
         this.nc.call("flagThis",null,_loc2_,this.myIP);
         this.closecam1();
      }
      
      public function EncryptStringRijndael55(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:Rijndael = new Rijndael();
         _loc3_ = _loc2_.encrypt(param1,this.rijndael_key5,"ECB");
         this.myIPencrypted = _loc3_;
      }
      
      public var userIPdecrypted:String;
      
      public function decryptStringRijndael5(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:Rijndael = new Rijndael();
         _loc3_ = _loc2_.decrypt(param1,this.rijndael_key5,"ECB");
         this.userIPdecrypted = _loc3_;
      }
      
      public var maxCamVtime:Number;
      
      public var freeCamTimeN:Number;
      
      public var timeWatched:Number;
      
      public var minutesToGo:String;
      
      public var bigCamTimer:Timer;
      
      public function countdown(param1:TimerEvent) : *
      {
         var _loc2_:Number = this.freeCamTimeN - this.bigCamTimer.currentCount;
      }
      
      public var soundXForm:SoundTransform;
      
      public var publish_ns:NetStream;
      
      public var play_ns:NetStream;
      
      public var ctrlON:Boolean;
      
      public function stopBigCam() : void
      {
         this.mainTimeOut();
         this.tracker.trackPageview("TIMEOUT_Show_Big_Cam_Graphic");
         if(this.sending_video)
         {
            this.stopCam();
         }
      }
      
      public function closecam1() : *
      {
         this.play_ns.close();
         this.receiving_video = false;
         this.Application.cam1.visible = false;
         this.Application.cam1.cam1_wtxt.text = "";
         this.bigCamTimer.stop();
         this.nc.call("watchingWho",null,null);
      }
      
      public function manageStreams() : void
      {
         this.publish_ns = new NetStream(this.nc);
         this.play_ns = new NetStream(this.nc);
         this.play_ns.addEventListener(NetStatusEvent.NET_STATUS,this.videoStatusEvent);
         this.play_ns.client = this;
         this.publish_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
         this.publish_ns.client = this;
      }
      
      public function asyncErrorHandler(param1:AsyncErrorEvent) : void
      {
      }
      
      public function camStatusEvent(param1:Object) : void
      {
      }
      
      public function videoStatusEvent(param1:Object) : void
      {
         if(param1.info.code == "NetStream.Buffer.Full")
         {
            this.soundXForm.volume = this.Application.cam1.volMC.volSlide.value;
            this.tracker.trackPageview("NetStream Status: " + param1.info.code);
            this.Application.cam1.load_anim.visible = false;
         }
         else if(param1.info.code == "NetStream.Play.Reset")
         {
            this.Application.cam1.video1.clear();
            this.Application.cam1.load_anim.visible = true;
            this.Application.cam1.flag_bt.enabled = true;
            this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser);
         }
         else if(param1.info.code == "NetStream.Play.UnpublishNotify")
         {
            this.closecam1();
            this.tracker.trackPageview(param1.info.code);
         }
         else if(param1.info.code == "NetStream.Buffer.Empty")
         {
            this.Application.cam1.load_anim.visible = true;
         }
         else if(param1.info.code == "NetStream.Video.DimensionChange")
         {
         }
         
         
         
         
      }
      
      public function HandleMouseOver(param1:MouseEvent) : *
      {
         this.Application.cam1.volMC.visible = true;
         this.Application.cam1.close_bt.visible = true;
         this.Application.cam1.invite_bt.visible = true;
         this.Application.cam1.flag_bt.visible = true;
         this.Application.cam1.underbutt.visible = true;
         this.Application.cam1.likeCam.visible = true;
      }
      
      public function HandleMouseOut(param1:MouseEvent) : *
      {
         this.Application.cam1.volMC.visible = false;
         this.Application.cam1.close_bt.visible = false;
         this.Application.cam1.invite_bt.visible = false;
         this.Application.cam1.flag_bt.visible = false;
         this.Application.cam1.underbutt.visible = false;
         this.Application.cam1.likeCam.visible = false;
      }
      
      public function playStream(param1:String, param2:String, param3:String) : void
      {
         this.play_ns.close();
         if(this.imgLoad == true)
         {
            this.imageLoader.unload();
            this.Application.cam1.flagArea.removeChild(this.imageLoader);
            this.imgLoad = false;
         }
         this.loadImage(param3);
         this.Application.cam1.visible = true;
         this.Application.cam1.load_anim.visible = true;
         this.play_ns.soundTransform = this.soundXForm;
         if(this.mobileStream)
         {
            this.Application.cam1.video1.visible = false;
            this.Application.cam1.video1m.visible = true;
            this.Application.cam1.video1m.attachNetStream(this.play_ns);
         }
         if(!this.mobileStream)
         {
            this.Application.cam1.video1.visible = true;
            this.Application.cam1.video1m.visible = false;
            this.Application.cam1.video1.attachNetStream(this.play_ns);
         }
         this.play_ns.bufferTime = 2;
         this.play_ns.play(param1);
         this.receiving_video = true;
         this.Application.cam1.cam1_txt.text = param1 + ", " + param2;
         this.Application.cam1.cam1_wtxt.text = param1;
         this.tracker.trackEvent("WATCHING CAM","play",param1);
         if(this.timeOut == true)
         {
            this.timeOut88.start();
            return;
         }
         if(this.myGender == "female" && this.sending_video == false)
         {
            this.bigCamTimer.start();
            return;
         }
         if(this.myGender == "couple")
         {
            this.bigCamTimer.start();
            return;
         }
         if(this.myGender == "male")
         {
            this.bigCamTimer.start();
            return;
         }
      }
      
      public function volChange(param1:SliderEvent) : void
      {
         if(param1.value == 0)
         {
            this.Application.cam1.volMC.muteIcon.visible = true;
         }
         else if(param1.value != 0)
         {
            this.Application.cam1.volMC.muteIcon.visible = false;
         }
         
         this.soundXForm.volume = param1.value;
         this.play_ns.soundTransform = this.soundXForm;
      }
      
      public var curSelectionUser:String;
      
      public var tempPW:String;
      
      public var theWho:String;
      
      public var goingToRoom:String;
      
      public var doSyncOnce:Boolean;
      
      public var myIPencrypted:String;
      
      public var uCounter:Number;
      
      public var uCounterCurrent:Number;
      
      public var mobileStream:Boolean;
      
      public var updateTimer:Timer;
      
      public function onTimeUp(param1:TimerEvent) : void
      {
         this.doSyncOnce = true;
      }
      
      public var updateTimer67:Timer;
      
      public function onTimeUp888(param1:TimerEvent) : void
      {
         this.users_so.addEventListener(SyncEvent.SYNC,this.syncEventHandler2);
      }
      
      public function manageSO() : void
      {
         this.users_so = SharedObject.getRemote("users_so",this.nc.uri,false);
         this.chat_so = SharedObject.getRemote("chat_so",this.nc.uri,false);
         this.rooms_so = SharedObject.getRemote("public/roomsAndUsers",this.nc.uri,true);
         this.rooms_so.addEventListener(SyncEvent.SYNC,this.syncEventHandler);
         this.users_so.addEventListener(SyncEvent.SYNC,this.syncEventHandler2);
         this.users_so.connect(this.nc);
         this.rooms_so.connect(this.nc);
         this.chat_so.connect(this.nc);
         this.chat_so.client = this;
         this.doSyncOnce = true;
      }
      
      public var usersDP:DataProvider;
      
      public function displayMessages() : void
      {
         var _loc2_:Object = null;
         this.Application.History.htmlText = "";
         var _loc1_:Array = this.messages.slice(-20);
         if(this.messages.length >= 20)
         {
            this.messages.splice(0,1);
         }
         for each(_loc2_ in _loc1_)
         {
            this.Application.History.htmlText = this.Application.History.htmlText + _loc2_.chatMsg;
            this.Application.History.scrollV = this.Application.History.maxScrollV;
         }
      }
      
      public function syncEventHandler(param1:SyncEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.doSyncOnce)
         {
            this.roomsDP.removeAll();
            for(_loc2_ in this.rooms_so.data)
            {
               if(this.rooms_so.data[_loc2_] != null)
               {
                  _loc3_ = this.rooms_so.data[_loc2_];
                  _loc4_ = "room_icon";
                  if(_loc3_.roomName == "Lobby")
                  {
                     this.uCounter = _loc3_.roomUsers;
                  }
                  if(_loc3_.roomName == this.roomTitle)
                  {
                     this.uCounterCurrent = _loc3_.roomUsers;
                  }
                  if(_loc3_.password != "")
                  {
                     _loc4_ = "key_mc";
                  }
                  if(_loc3_.roomUsers > 99)
                  {
                     _loc4_ = "hotroom_icon";
                  }
                  if(_loc3_.roomUsers < 20 && _loc3_.password == "")
                  {
                     _loc4_ = "coldroom_icon";
                  }
                  if(_loc3_.roomVip == true)
                  {
                     _loc4_ = "viproom_icon";
                  }
                  if(_loc3_.autoRoom == true)
                  {
                     _loc4_ = "heart_mc";
                  }
                  if(!(_loc3_.roomName == "") && _loc3_.autoRoom == true)
                  {
                     this.roomsDP.addItem({
                        "label":"Privado (2)",
                        "data":_loc3_.roomID,
                        "nombre":_loc3_.roomName,
                        "icon":_loc4_,
                        "owner":_loc3_.owner,
                        "topic":_loc3_.roomTopic,
                        "lock":"94uwjjrs92845hwos083hj5w0eips0w4ji54st46464ss",
                        "roomUserCount":_loc3_.roomUsers,
                        "vipRoom":_loc3_.roomVip,
                        "autoRoom":_loc3_.autoRoom,
                        "sorted":_loc3_.sortRoom,
                        "roomObj":_loc3_
                     });
                     this.roomsDP.sortOn(["sorted","lock"]);
                  }
                  else
                  {
                     this.roomsDP.addItem({
                        "label":_loc3_.roomName + " (" + _loc3_.roomUsers + ")",
                        "data":_loc3_.roomID,
                        "nombre":_loc3_.roomName,
                        "icon":_loc4_,
                        "owner":_loc3_.owner,
                        "topic":_loc3_.roomTopic,
                        "lock":_loc3_.password,
                        "roomUserCount":_loc3_.roomUsers,
                        "vipRoom":_loc3_.roomVip,
                        "autoRoom":_loc3_.autoRoom,
                        "sorted":_loc3_.sortRoom,
                        "roomLimit":_loc3_.roomLimit,
                        "roomObj":_loc3_
                     });
                     this.roomsDP.sortOn(["sorted","lock"]);
                  }
                  this.doSyncOnce = false;
                  this.updateTimer.start();
               }
            }
         }
      }
      
      public function syncEventHandler2(param1:SyncEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.usersDP.removeAll();
         for(_loc2_ in this.users_so.data)
         {
            if(this.users_so.data[_loc2_] != null)
            {
               _loc3_ = this.users_so.data[_loc2_];
               if(_loc3_.UserName == "")
               {
                  return;
               }
               if(_loc3_.UserName == this.Application.cam1.cam1_wtxt.text)
               {
                  this.Application.cam1.likeCam.label = _loc3_.votesUp.toString();
               }
               if(_loc3_.UserName == this.Application.cam2.cam1_wtxt.text)
               {
                  this.Application.cam2.likeCam.label = _loc3_.votesUp.toString();
               }
               if(_loc3_.UserName == this.Application.cam3.cam1_wtxt.text)
               {
                  this.Application.cam3.likeCam.label = _loc3_.votesUp.toString();
               }
               this.usersDP.addItem({
                  "label":_loc3_.UserName,
                  "data":_loc3_.UserName,
                  "gender":_loc3_.gender,
                  "streaming":_loc3_.userstatus,
                  "iswatching":_loc3_.iswatching,
                  "camtype":_loc3_.camtype,
                  "pais":_loc3_.pais,
                  "age":_loc3_.age,
                  "isMobile":_loc3_.mobileUser,
                  "vipCam":_loc3_.vipCam
               });
               this.usersDP.sortOn([this.listStatus,"gender","label"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
               this.users_so.removeEventListener(SyncEvent.SYNC,this.syncEventHandler2);
               this.updateTimer67.start();
            }
         }
      }
      
      public function determineIcon(param1:Object) : String
      {
         if(param1.iswatching == this.myName)
         {
            if(param1.gender == "male" && param1.streaming == "online")
            {
               return "male_watches";
            }
            if(param1.gender == "male" && param1.streaming == "idle")
            {
               return "male_cam_watches";
            }
            if(param1.gender == "couple" && param1.streaming == "online")
            {
               return "couple_watches";
            }
            if(param1.gender == "couple" && param1.streaming == "idle")
            {
               return "couple_cam_watches";
            }
            if(param1.gender == "female" && param1.streaming == "online")
            {
               return "female_watches";
            }
            if(param1.gender == "female" && param1.streaming == "idle")
            {
               return "female_cam_watches";
            }
         }
         if(param1.iswatching != this.myName)
         {
            if(param1.gender == "male" && param1.streaming == "online")
            {
               return "male";
            }
            if(param1.gender == "male" && param1.streaming == "idle")
            {
               return "male_cam";
            }
            if(param1.gender == "couple" && param1.streaming == "online")
            {
               return "couple";
            }
            if(param1.gender == "couple" && param1.streaming == "idle")
            {
               return "couple_cam";
            }
            if(param1.gender == "female" && param1.streaming == "online")
            {
               return "female";
            }
            if(param1.gender == "female" && param1.streaming == "idle")
            {
               return "female_cam";
            }
         }
         return "";
      }
      
      public var roomsDP:DataProvider;
      
      public function changeRoom(param1:Event) : void
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = param1.target.selectedItem.data;
         this.roomID = _loc2_;
         var _loc3_:* = param1.target.selectedItem.lock;
         var _loc4_:* = param1.target.selectedItem.roomUserCount;
         var _loc5_:* = param1.target.selectedItem.vipRoom;
         this.goingToRoom = param1.target.selectedItem.nombre;
         var _loc6_:* = param1.target.selectedItem.roomLimit;
         var _loc7_:* = param1.target.selectedItem.owner;
         var _loc8_:* = param1.target.selectedItem.autoRoom;
         if(_loc2_ == this.currentRoomID)
         {
            return;
         }
         if(_loc2_ == null)
         {
            return;
         }
         if(this.roomTitle == this.goingToRoom)
         {
            return;
         }
         if(param1.target.selectedItem.data == undefined)
         {
            return;
         }
         this.myName = this.minutesToGo;
         this.myGender = this.minutesToGo2;
         this.myAge = this.timeWatched;
         this.myCountry = this.adminStr;
         if(_loc3_ == "94uwjjrs92845hwos083hj5w0eips0w4ji54st46464ss")
         {
            this.myName = "     ";
            this.myGender = "zzzz";
            this.myCountry = "    ";
            this.myAge = 18;
         }
         if(!(_loc3_ == "") && !_loc8_)
         {
            this.tempPW = _loc3_;
            this.Application.filters = [this.bf];
            this.enterRoomMC.visible = true;
            this.enterRoomMC.claveSala.setFocus();
            return;
         }
         this.changingRoom = true;
         this.Application.people_lb.removeAll();
         this.Application.people_lb.addItem({"label":"Cargando.."});
         this.doDisconnect();
         this.connectApp();
      }
      
      public function doSendPV(param1:MouseEvent) : void
      {
         this.sendPVMsg();
      }
      
      public function sendPVMsg() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:* = this.Application.mensPv.pv_msg.text;
         var _loc2_:* = this.curSelectionUser;
         var _loc3_:* = "#0000FF";
         if(!(_loc1_ == "") && !(this.curSelectionUser == null))
         {
            this.Application.mensPv.pv_msg.text = "";
            this.nc.call("msgFromClient",null,_loc1_,_loc3_,_loc2_,this.myIPencrypted);
            _loc4_ = "<font face=\'Tahoma\' size=\'15\' color=\'#0000FF\'><b>MP para " + _loc2_ + ": </b></font> <font face=\'Tahoma\' size=\'15\' color=\'#FF0000\'><b>" + _loc1_ + "</b></font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc4_;
         }
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function doSend(param1:MouseEvent) : void
      {
         this.sendMsg();
      }
      
      public function sendMsg() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.Application.msg.text == "")
         {
            return;
         }
         var _loc1_:* = this.Application.msg.text;
         if(_loc1_ != "")
         {
            this.filterWord(_loc1_);
            this.Application.msg.text = "";
         }
      }
      
      public var sendMsgTimeOut:Boolean;
      
      public var sendMsgTimer:Timer;
      
      public function sendMsgTImerDone(param1:TimerEvent) : void
      {
      }
      
      public var badWords:Array;
      
      public var badWordsLoader:URLLoader;
      
      public function badWordsError(param1:IOErrorEvent) : void
      {
      }
      
      public function onLoaded(param1:Event) : void
      {
         this.badWords = param1.target.data.split(",");
      }
      
      public function filterWord(param1:String) : Boolean
      {
         var _loc3_:* = 0;
         var _loc2_:* = param1;
         _loc3_ = 0;
         this.nc.call("chatUser",null,param1,this.myName,this.myColor,this.myIPencrypted,this.Eql9844kmgldiroURrX998q12Vgm);
         this.tracker.trackPageview("MESSAGE SENT BY REGULAR USER: " + this.myName);
         return false;
      }
      
      public function onTextSelect(param1:FocusEvent) : void
      {
         this.Application.fontSel.visible = false;
      }
      
      public function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.sendMsg();
            this.sendPVMsg();
         }
      }
      
      public function doDisconnect() : void
      {
         this.closecam1();
         this.closePVwin();
         this.tracker.trackPageview("doDisconnect Called");
         this.nc.close();
      }
      
      public function selectedUser(param1:Event) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         this.curSelectionUser = param1.target.selectedItem.label;
         this.theWho = this.curSelectionUser;
         var _loc2_:* = param1.target.selectedItem.streaming;
         var _loc3_:* = param1.target.selectedItem.age;
         var _loc4_:* = param1.target.selectedItem.pais;
         var _loc5_:* = param1.target.selectedItem.vipCam;
         var _loc6_:* = param1.target.selectedItem.likes;
         this.mobileStream = param1.target.selectedItem.isMobile;
         this.Application.msg.setFocus();
         this.Application.mensPv.toWhoPV.htmlText = "<font color=\'#000000\'>Mensaje privado para:</font> <font color=\'#FF0000\'>" + this.curSelectionUser + "</font>";
         this.Application.mensPv.visible = true;
         this.Application.History.y = 344;
         this.Application.History.height = 237;
         if(this.curSelectionUser == this.myName)
         {
            this.theWho = undefined;
            this.closePVwin();
            return;
         }
         if(_loc2_ == "idle")
         {
            this.playStream(this.curSelectionUser,_loc3_,_loc4_);
         }
      }
      
      public function closePV(param1:MouseEvent) : *
      {
         this.closePVwin();
      }
      
      public function closePVwin() : void
      {
         this.tracker.trackPageview("PV WINDOW CLOSED");
         this.Application.mensPv.visible = false;
         this.Application.mensPv.pv_msg.text = "";
         this.Application.History.y = 265;
         this.Application.History.height = 316;
      }
      
      public function showLogout(param1:MouseEvent) : void
      {
         this.Application.myTooltip.content = "Cerrar sesión";
         this.Application.myTooltip.show();
      }
      
      public function hideLogout(param1:MouseEvent) : void
      {
         this.Application.myTooltip.hide();
      }
      
      public function showFlagTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip2.type = "image";
         this.Application.myTooltip2.content = myMC;
         this.Application.myTooltip2.show();
      }
      
      public function hideFlagTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip2.hide();
      }
      
      public function showCreateTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip.content = "Crear y Moderar Sala de VideoChat";
         this.Application.myTooltip.show();
      }
      
      public function hideCreateTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip.hide();
      }
      
      public function showInviteTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam1.cam1_wtxt.text + "</b> a una sala privada";
         this.Application.myTooltip.show();
      }
      
      public function showInviteTip2(param1:MouseEvent) : void
      {
         this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam2.cam1_wtxt.text + "</b> a una sala privada";
         this.Application.myTooltip.show();
      }
      
      public function showInviteTip3(param1:MouseEvent) : void
      {
         this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam3.cam1_wtxt.text + "</b> a una sala privada";
         this.Application.myTooltip.show();
      }
      
      public function hideInviteTip(param1:MouseEvent) : void
      {
         this.Application.myTooltip.hide();
      }
      
      public function showUserInfo(param1:ListEvent) : void
      {
         var _loc2_:* = this.Application.people_lb.getItemAt(param1.index).ip2;
         var _loc3_:* = this.Application.people_lb.getItemAt(param1.index).vipCam;
         var _loc4_:* = this.Application.people_lb.getItemAt(param1.index).age;
         var _loc5_:* = this.Application.people_lb.getItemAt(param1.index).pais;
         var _loc6_:* = this.Application.people_lb.getItemAt(param1.index).iswatching;
         var _loc7_:* = this.Application.people_lb.getItemAt(param1.index).camtype;
         if(_loc4_ < 18)
         {
            _loc4_ = 18;
         }
         this.Application.myTooltip.content = "Pais: <b>" + _loc5_ + "</b><br>Edad: <b>" + _loc4_ + "</b><br>IP: <b>" + _loc2_ + "</b><br>VipCam: <b>" + _loc3_ + "</b><br>Mirando: <b>" + _loc6_ + "</b><br>CamType: <b>" + _loc7_ + "</b>";
         if(_loc4_ != undefined)
         {
            this.Application.myTooltip.show();
         }
      }
      
      public function showRoomInfo(param1:ListEvent) : void
      {
         this.Application.myTooltip.hide();
         var _loc3_:* = this.Application.rooms_lb.getItemAt(param1.index).lock;
         var _loc5_:Rijndael = new Rijndael();
         _loc3_ = _loc5_.decrypt(_loc3_,this.rijndael_key,"ECB");
         var _loc2_:* = this.Application.rooms_lb.getItemAt(param1.index).owner;
         var _loc4_:* = this.Application.rooms_lb.getItemAt(param1.index).topic;
         this.Application.myTooltip.content = "Moderador:  <b>" + _loc2_ + "</b><br>Topic: <b>" + _loc4_ + "</b><br>Clave: <b>" + _loc3_ + "</b>";
         this.Application.myTooltip.show();
      }
      
      public function hideUserInfo(param1:ListEvent) : void
      {
         this.Application.myTooltip.hide();
      }
      
      public function ignoTip(param1:String) : void
      {
         this.Application.myTooltip.content = param1;
         this.Application.myTooltip.show();
         this.myTimer.start();
      }
      
      public function hideIgnoTip(param1:TimerEvent) : void
      {
         this.Application.myTooltip.hide();
      }
      
      public var myTimer:Timer;
      
      public var h264Config:H264VideoStreamSettings;
      
      public var cam:Camera;
      
      public var mic:Microphone;
      
      public var deviceName:String;
      
      public var mic_on:Boolean;
      
      public var camTimeUp:Boolean;
      
      public var minutesToGo2:String;
      
      public var sendCamTimeN:Number;
      
      public var maleCamTimer:Timer;
      
      public function countdown4(param1:TimerEvent) : *
      {
      }
      
      public function showLevel(param1:Event) : void
      {
         this.Application.myCamMC.micMeter.colorBar.height = this.mic.activityLevel * 0.875;
      }
      
      public function setMicLevel(param1:SliderEvent) : void
      {
         this.mic.gain = param1.value;
         this.tracker.trackPageview("VOLUME CHANGED");
      }
      
      public function cameraHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.sending_video)
         {
            this.stopCam();
            return;
         }
         if(this.timeOut == true)
         {
            this.tracker.trackPageview("StartCam Clicked but TimedOut :(");
            _loc2_ = "<b><font face=\'Tahoma\' size=\'14\' color=\'#FF0000\'>Todos los espacios gratis estan ocupados, <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Regístrate</a></u></font> para acceso sin límites!</font></b>";
            this.messages.push({"chatMsg":_loc2_});
            this.displayMessages();
            this.Application.activateCam.selected = false;
            return;
         }
         if(this.camTimeUp == true)
         {
            this.tracker.trackPageview("MALE SEND CAM TIMEUP");
            _loc3_ = "<b><font face=\'Tahoma\' size=\'14\' color=\'#FF0000\'>Tu tiempo de enviar cámara gratis ha terminado, <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Regístrate</a></u></font> para acceso sin límites!</font></b>";
            this.messages.push({"chatMsg":_loc3_});
            this.displayMessages();
            this.Application.activateCam.selected = false;
            return;
         }
         if(param1.target.selected == true)
         {
            this.startCam();
         }
         else
         {
            this.stopCam();
         }
      }
      
      public function bellHandler(param1:MouseEvent) : void
      {
         if(param1.target.selected == true)
         {
            this.Application.optionsMC.bellOff.visible = false;
            this.Application.optionsMC.bellOn.visible = true;
            this.bellSound = true;
         }
         else
         {
            this.Application.optionsMC.bellOff.visible = true;
            this.Application.optionsMC.bellOn.visible = false;
            this.bellSound = false;
         }
      }
      
      public function vipCamHandler(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("USER SET WEBCAM TO VIP (failed!, non-vip)");
         this.showAlerts("\nSolamente usuarios registrados\npueden usar esta opción.");
         this.Application.optionsMC.vipCheck.selected = false;
      }
      
      public function micHandler(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var cameraHandler:Function = function(param1:MouseEvent):void
         {
            if(param1.target.selected == true)
            {
               startCam();
            }
            else
            {
               stopCam();
            }
         };
         if(event.target.selected == true)
         {
            this.startMic();
         }
         else
         {
            this.stopMic();
         }
      }
      
      public function startMic() : void
      {
         this.mic = Microphone.getMicrophone();
         if(this.mic)
         {
            this.mic.setSilenceLevel(0);
            this.mic.codec = SoundCodec.PCMA;
            this.mic.gain = this.Application.myCamMC.micVol.value;
            this.mic.noiseSuppressionLevel = 0;
            this.mic.setUseEchoSuppression(true);
            stage.addEventListener(Event.ENTER_FRAME,this.showLevel);
            this.mic_on = true;
            this.publish_ns.attachAudio(this.mic);
            this.Application.activateMic.selected = true;
         }
         this.Application.myCamMC.micVol.visible = true;
         this.Application.myCamMC.micIcon1.visible = true;
         this.Application.myCamMC.micMeter.visible = true;
      }
      
      public function stopMic() : void
      {
         this.mic.gain = 0;
         this.mic_on = false;
         this.Application.myCamMC.micVol.visible = false;
         this.Application.myCamMC.micIcon1.visible = false;
         this.Application.myCamMC.micMeter.visible = false;
         this.Application.activateMic.selected = false;
         stage.removeEventListener(Event.ENTER_FRAME,this.showLevel);
         this.tracker.trackPageview("MIC STOPPED");
      }
      
      public function stopCam() : void
      {
         this.fakeTimer.stop();
         this.publish_ns.close();
         this.Application.myCamMC.visible = false;
         this.nc.call("updateStatus",null,"online");
         this.sending_video = false;
         this.Application.myCamMC.myCam.attachCamera(null);
         this.publish_ns.attachCamera(null);
         this.maleCamTimer.stop();
         this.Application.activateMic.enabled = false;
         this.Application.activateMic.selected = false;
         this.Application.activateCam.selected = false;
         this.Application.myCamMC.micVol.visible = false;
         this.Application.myCamMC.micIcon1.visible = false;
         this.Application.myCamMC.micMeter.visible = false;
      }
      
      public function startCam() : void
      {
         var _loc1_:String = null;
         this.cam = Camera.getCamera();
         if(Camera.names.length > 0)
         {
            if(this.camTimeUp == true)
            {
               this.stopCam();
               return;
            }
            this.publish_ns = new NetStream(this.nc);
            this.publish_ns.videoStreamSettings = this.h264Config;
            this.h264Config.setProfileLevel(H264Profile.BASELINE,H264Level.LEVEL_1);
            this.deviceName = this.cam.name;
            this.cam.addEventListener(StatusEvent.STATUS,this.camStatusHandler);
            this.tracker.trackPageview("CAMERA FOUND, STARTING CAMERA");
            this.cam.setQuality(this.camQ,0);
            this.cam.setMode(320,240,this.camFPS);
            this.cam.setKeyFrameInterval(30);
            this.Application.myCamMC.myCam.attachCamera(this.cam);
            this.Application.myCamMC.visible = true;
            this.publish_ns.attachCamera(this.cam);
            this.publish_ns.publish(this.myName,"live");
            this.publish_ns.bufferTime = 0;
            this.Application.myCamMC.micMeter.visible = false;
            this.Application.activateMic.enabled = true;
            this.Application.activateCam.selected = true;
            if(this.myGender != "female")
            {
               this.maleCamTimer.start();
            }
            this.sending_video = true;
            this.startMic();
            this.tracker.trackPageview("CAM STARTED");
            this.fakeTimer.start();
            this.nc.call("updateMyVotes",null,this.local_so.data.myVotes);
            this.nc.call("updateCamStatus",null,this.deviceName);
            this.nc.call("updateStatus",null,"idle");
            if(this.cam.muted)
            {
               this.tracker.trackPageview("CAMERA IS MUTED, STOP BROADCAST");
               this.stopCam();
               Security.showSettings(SecurityPanel.PRIVACY);
            }
         }
         else
         {
            _loc1_ = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'><b>No se ha detectado cámara en tu ordenador, conecta una cámara e intenta de nuevo</b></font>";
            this.messages.push({"chatMsg":_loc1_});
            this.displayMessages();
            this.Application.activateCam.selected = false;
            this.tracker.trackPageview("NO CAMERA FOUND");
         }
      }
      
      public function camStatusHandler(param1:StatusEvent) : void
      {
         this.tracker.trackPageview(param1.code);
         if(Camera.names.length > 0)
         {
            this.tracker.trackPageview(param1.code);
            if(param1.code == "Camera.Muted")
            {
               this.stopCam();
            }
            else
            {
               if(this.timeOut == true)
               {
                  return;
               }
               this.Application.activateCam.selected = true;
               this.Application.activateMic.enabled = true;
               this.Application.myCamMC.visible = true;
               this.startCam();
            }
         }
      }
      
      public function badCamsError(param1:IOErrorEvent) : void
      {
         this.tracker.trackPageview("Error al cargar badCams.txt");
      }
      
      public function onBadCamsLoaded(param1:Event) : void
      {
         this.bannedDevices = param1.target.data.split(",");
      }
      
      public var fakeTimer:Timer;
      
      public function fakeTick(param1:TimerEvent) : *
      {
         var _loc2_:* = undefined;
         if(this.timeOut == true)
         {
            this.stopCam();
         }
         if(this.deviceName == "WebcamMax Capture Fast")
         {
            _loc2_ = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>* Por favor selecciona otra cámara, </font><font color=\'#000000\'>" + this.deviceName + "</font><font color=\'#FF0000\'> no es compatible con ChatVideo</font>";
            this.messages.push({"chatMsg":_loc2_});
            this.displayMessages();
            this.tracker.trackPageview("BANNED DEVICE: " + this.deviceName);
            this.stopCam();
            return;
         }
         if(this.deviceName == null)
         {
            return;
         }
         if(this.sending_video == true)
         {
            this.startsWith(this.deviceName,this.bannedDevices,6);
         }
      }
      
      public function startsWith(param1:String, param2:Array, param3:uint) : Array
      {
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc4_:Array = [];
         for each(_loc5_ in param2)
         {
            if(_loc5_.match("^" + param1.substr(0,param3)))
            {
               this.stopCam();
               _loc6_ = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>* Por favor selecciona otra cámara, </font><font color=\'#000000\'>" + param1 + "</font><font color=\'#FF0000\'> no es compatible con ChatVideo</font>";
               this.messages.push({"chatMsg":_loc6_});
               this.displayMessages();
               this.tracker.trackPageview("BANNED DEVICE: " + param1);
               Security.showSettings(SecurityPanel.CAMERA);
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      public function showCamConf(param1:MouseEvent) : void
      {
         Security.showSettings(SecurityPanel.CAMERA);
      }
      
      public function doLogout(param1:MouseEvent) : void
      {
         this.changingRoom = true;
         this.Application.visible = false;
         this.doDisconnect();
         this.showAlerts("\n\nHas cerrado sesión.");
      }
      
      public var rijndael_key:String;
      
      public var myRoomPW:String;
      
      public var sendRoomKey:String;
      
      public function createNR(param1:MouseEvent) : void
      {
         /*
          * Error de decompilación
          * El código puede estar ofuscado
          * Tip: You can try enabling "Automatic deobfucation" in Settings
          * Tipo de error: NullPointerException
          */
         throw new flash.errors.IllegalOperationError("No decompilado debido a un error");
      }
      
      public function closeNR(param1:MouseEvent) : void
      {
         this.closeWinNR();
      }
      
      public function closeWinNR() : void
      {
         this.newRmc.visible = false;
         this.newRmc.newRN.text = "";
         this.newRmc.newRD.text = "";
         this.newRmc.newRP.text = "";
         this.Application.filters = null;
         this.Application.msg.setFocus();
      }
      
      public function createRoomHandler(param1:MouseEvent) : void
      {
         this.Application.filters = [this.bf];
         this.newRmc.visible = true;
         this.newRmc.newRN.setFocus();
      }
      
      public function enterPWroom(param1:MouseEvent) : void
      {
         this.myName = "     ";
         this.myGender = "zzzz";
         this.myCountry = "    ";
         this.myAge = 18;
         this.decryptStringRijndael();
      }
      
      public function enterPWroomClose(param1:MouseEvent) : void
      {
         this.decryptStringRijndael();
      }
      
      public function EncryptStringRijndael() : void
      {
         var _loc2_:String = null;
         var _loc1_:Rijndael = new Rijndael();
         _loc2_ = _loc1_.encrypt(this.newRmc.newRP.text,this.rijndael_key,"ECB");
         this.myRoomPW = _loc2_;
      }
      
      public function decryptStringRijndael() : void
      {
         this.keyRoomStr = this.tempPW;
         this.enterRoomMC.visible = false;
         this.enterRoomMC.badpwd.visible = false;
         this.changingRoom = true;
         this.Application.people_lb.removeAll();
         this.Application.people_lb.addItem({"label":"Cargando..."});
         this.closecam1();
         this.closePVwin();
         this.doDisconnect();
         this.Application.filters = null;
         this.enterRoomMC.claveSala.text = "";
         this.enterRoomMC.badpwd.visible = false;
         this.connectApp();
      }
      
      public var sendInvitation:Boolean;
      
      public var inviteToWho:String;
      
      public function runInvite(param1:MouseEvent) : void
      {
         this.inviteToWho = this.Application.cam1.cam1_wtxt.text;
         this.sendInvite();
      }
      
      public function runInvite4(param1:MouseEvent) : void
      {
         this.inviteToWho = this.curSelectionUser;
         this.sendInvite();
      }
      
      public function sendInvite() : void
      {
         var _loc1_:* = this.inviteToWho;
         if(_loc1_ == this.myName)
         {
            this.Application.History.htmlText = this.Application.History.htmlText + "<font face=\'Arial\' color=\'#ff0000\' size=\'12\'>* No te puedes invitar a ti mism@!</font>";
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
         }
         if(this.sendInvitation == false)
         {
            this.Application.History.htmlText = this.Application.History.htmlText + "<font face=\'Tahoma\' color=\'#FF0000\' size=\'12\'>* Espera unos segundos antes de enviar otra invitacion :-)</font>";
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
         }
         if(_loc1_ != undefined)
         {
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' color=\'#0000FF\' size=\'12\'>* <font color=\'#FF0000\'>" + _loc1_ + "</font> ha sido invitad@ a una sala privada...</font>");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.sendInvitation = true;
         }
      }
      
      public function inviteAccept(param1:String) : void
      {
         this.tracker.trackPageview("InvitationAccepted");
         var _loc2_:Timer = new Timer(2000,1);
         _loc2_.addEventListener(TimerEvent.TIMER,this.goPV2);
         var _loc3_:* = new Object();
         _loc3_.roomUsers = 0;
         _loc3_.roomName = "~PV" + this.generateRandomString(5);
         _loc3_.roomTopic = "privado";
         _loc3_.roomVip = false;
         _loc3_.sortRoom = 888888888 + this.generateRandomString(4);
         _loc3_.autoRoom = true;
         _loc3_.roomID = "room_" + this.generateRandomString(20);
         _loc3_.isPrivate = true;
         _loc3_.password = "********";
         _loc3_.owner = param1;
         this.rooms_so.setProperty(_loc3_.roomID,_loc3_);
         this.roomID = _loc3_.roomID;
         this.changingRoom = true;
         this.nc.call("goPV",null,param1,this.roomID);
         _loc2_.start();
      }
      
      public function goPV2(param1:TimerEvent) : void
      {
         this.Application.History.htmlText = "";
         this.doDisconnect();
         this.connectApp();
      }
      
      public function generateRandomString(param1:Number) : String
      {
         var _loc2_:* = "abcdefghijklmnopqrstuvwxyz0123456789";
         var _loc3_:Number = _loc2_.length - 1;
         var _loc4_:* = "";
         var _loc5_:Number = 0;
         while(_loc5_ < param1)
         {
            _loc4_ = _loc4_ + _loc2_.charAt(Math.floor(Math.random() * _loc3_));
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function mainTimeOut() : void
      {
         this.timeOut = true;
         this.Application.bigRegister.visible = true;
         this.tracker.trackPageview("mainTimeOut Started");
         if((this.sending_video) && !(this.myGender == "female"))
         {
            this.stopCam();
         }
         if(this.receiving_video)
         {
            this.closecam1();
         }
      }
      
      public var timeOut88:Timer;
      
      public function tempo66Expired(param1:TimerEvent) : void
      {
      }
      
      public function timeFormat(param1:int) : String
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 > 59)
         {
            _loc2_ = Math.floor(param1 / 60);
            _loc3_ = String(_loc2_);
            _loc4_ = String(param1 % 60);
         }
         else
         {
            _loc3_ = "";
            _loc4_ = String(param1);
         }
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         return _loc3_ + ":" + _loc4_;
      }
      
      public var imageLoader:Loader;
      
      public var flagPath:String;
      
      public var imgLoad:Boolean;
      
      public function loadImage(param1:String) : void
      {
         this.imageLoader = new Loader();
         this.imageLoader.load(new URLRequest(this.flagPath + param1 + ".png"));
         this.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoaded);
      }
      
      public function imageLoaded(param1:Event) : void
      {
         this.Application.cam1.flagArea.addChild(this.imageLoader);
         this.imgLoad = true;
      }
      
      public var imageLoader2:Loader;
      
      public var imgLoad2:Boolean;
      
      public function loadImage2(param1:String) : void
      {
         this.imageLoader2 = new Loader();
         this.imageLoader2.load(new URLRequest(this.flagPath + param1 + ".png"));
         this.imageLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoaded2);
      }
      
      public function imageLoaded2(param1:Event) : void
      {
         this.Application.cam2.flagArea.addChild(this.imageLoader2);
         this.imgLoad2 = true;
      }
      
      public var imageLoader3:Loader;
      
      public var imgLoad3:Boolean;
      
      public function loadImage3(param1:String) : void
      {
         this.imageLoader3 = new Loader();
         this.imageLoader3.load(new URLRequest(this.flagPath + param1 + ".png"));
         this.imageLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoaded3);
      }
      
      public function imageLoaded3(param1:Event) : void
      {
         this.Application.cam3.flagArea.addChild(this.imageLoader3);
         this.imgLoad3 = true;
      }
      
      public var local_so:SharedObject;
      
      public function storeLocalSO() : void
      {
         var soStatus:Function = null;
         soStatus = function(param1:NetStatusEvent):void
         {
            if(param1.info.code == "SharedObject.Flush.Failed")
            {
               if(isConnected == true)
               {
                  tracker.trackPageview("SHARED OBJECT FAILED TO FLUSH >>>_" + myCountry);
                  doDisconnect();
                  return;
               }
               login_mc.login_btn.enabled = false;
            }
         };
         var flushStatus:String = null;
         try
         {
            flushStatus = this.local_so.flush(1000);
         }
         catch(error:Error)
         {
            login_mc.login_btn.enabled = false;
            if(isConnected == true)
            {
               doDisconnect();
               return;
            }
            Security.showSettings(SecurityPanel.LOCAL_STORAGE);
         }
         if(flushStatus != null)
         {
            this.local_so.data.myName = this.myName;
            this.local_so.data.myGender = this.myGender;
            this.local_so.data.myAge = this.myAge;
            this.local_so.flush();
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  this.local_so.addEventListener(NetStatusEvent.NET_STATUS,soStatus);
                  break;
               case SharedObjectFlushStatus.FLUSHED:
                  break;
            }
         }
      }
      
      public var soTimer24:Timer;
      
      public function onTick24(param1:TimerEvent) : void
      {
         this.storeLocalSO();
      }
      
      public function mouseDownHandler4(param1:MouseEvent) : void
      {
         this.Application.myCamMC.startDrag();
         this.tracker.trackPageview("DRAGGING_MY_CAM");
      }
      
      public function mouseUpHandler4(param1:MouseEvent) : void
      {
         this.Application.myCamMC.stopDrag();
      }
      
      public function showAlerts(param1:*) : void
      {
         this.alertW.visible = true;
         this.alertW.msg.text = param1;
      }
      
      public function closeAlerts(param1:MouseEvent) : *
      {
         this.alertW.visible = false;
         this.alertW.msg.text = "";
      }
      
      public function inviteOnAccept(param1:MouseEvent) : void
      {
         this.alertW.visible = false;
         this.tracker.trackPageview("PRIVATE_INVIT_ACCEPTED");
         this.inviteAccept(this.inviteSender);
         this.alertW.ok_but.visible = true;
         this.alertW.accept_but.visible = false;
         this.alertW.deny_but.visible = false;
      }
      
      public function inviteOnReject(param1:MouseEvent) : void
      {
         this.alertW.visible = false;
         this.nc.call("PVrejected",null,this.inviteSender,this.myName);
         this.tracker.trackPageview("PRIVATE_INVIT_REJECTED");
         this.alertW.ok_but.visible = true;
         this.alertW.accept_but.visible = false;
         this.alertW.deny_but.visible = false;
      }
      
      public function likeUser(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam1.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'><b>Me gusta " + _loc2_ + "!</b></font>";
         this.messages.push({"chatMsg":_loc3_});
         this.displayMessages();
         this.tracker.trackPageview("LIKE SENT!");
         this.nc.call("likeYou",null,_loc2_,this.myName);
         this.Application.cam1.likeCam.removeEventListener(MouseEvent.CLICK,this.likeUser);
      }
      
      public function likeMe(param1:String) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.likeMeArray.length)
         {
            if(this.likeMeArray[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.likeMeArray.push(param1);
         this.nc.call("setVoteUp",null,this.myIP);
         this.tracker.trackPageview("LIKE RECEIVED");
      }
      
      private var nc:NetConnection;
      
      private var lc:LocalConnection;
      
      private var fms_gateway:String;
      
      private var fms_country:String;
      
      private var Eql9844kmgldiroURrX998q12Vgm:String;
      
      var tracker:AnalyticsTracker;
      
      var isVip:Boolean;
      
      var adminStr:String = "";
      
      var vipStr:String = "4893052JGMMGGM5858!03383@@Z";
      
      var stealthmode:Boolean = false;
      
      var rejected:Boolean = false;
      
      var myCountry:String = "";
      
      var countryConn:Boolean = true;
      
      var myName:String;
      
      var myGender:String = "";
      
      var myAge:Number;
      
      var myIP:String = "55.55.55.55";
      
      var isConnected:Boolean = false;
      
      var sending_video:Boolean = false;
      
      var sending_audio:Boolean = false;
      
      var receiving_video:Boolean = false;
      
      var receiving_video2:Boolean = false;
      
      var receiving_video3:Boolean = false;
      
      var receiving_video4:Boolean = false;
      
      var receiving_video5:Boolean = false;
      
      var firstAdminAuth:Boolean = true;
      
      var firstOwnerAuth:Boolean = true;
      
      var firstLogon:Boolean = true;
      
      var alertOn:Boolean = false;
      
      var roomTitle:String;
      
      var keyRoomStr:String;
      
      var bellSound:Boolean = true;
      
      var bannedDevices:Array;
      
      var badCamsLoader:URLLoader;
      
      var camIgnoringMe;
      
      var chat_so:SharedObject;
      
      var users_so:SharedObject;
      
      var rooms_so:SharedObject;
      
      var messages:Array;
      
      var timeOut:Boolean = false;
      
      var listStatus:String = "streaming";
      
      var maxUsers:Number;
      
      var limitedCamTime:Number;
      
      var localCookie:String = "DefaultCookie";
      
      var UserInfo:Object;
      
      var roomID:String;
      
      var lobbyID:String;
      
      var fms_nc:NetConnection;
      
      var camQ:Number;
      
      var camFPS:Number;
      
      var micQ:Number;
      
      var isRejected:Boolean = false;
      
      var changingRoom:Boolean = false;
      
      var currentRoomID:String;
      
      var ignoredPPL;
      
      var inviteSender:String;
      
      var inviteSenderIP:String;
      
      var flagMeArray;
      
      var likeMeArray;
      
      var flagMeLimit:Number;
      
      var doOnceTimers:Boolean = true;
      
      private function connectApp() : void
      {
         if(this.firstLogon)
         {
            this.adminStr = this.myCountry;
            this.setFontTypeSO();
            this.login_mc.conn_anim.visible = true;
         }
         this.nc.connect(this.fms_gateway + this.roomID,this.myName,this.myGender,"",this.stealthmode,this.myAge,this.myCountry,this.isVip,this.myIP,this.vipStr,this.keyRoomStr);
      }
      
      private function connectCountry() : void
      {
         this.nc.connect(this.fms_country);
         this.tracker.trackPageview("Connecting_Country_RTMP");
      }
      
      private function netStatusHandler(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               if(this.countryConn == true)
               {
                  return;
               }
               this.manageSO();
               if(this.firstLogon == true)
               {
                  this.Application.rooms_lb.addEventListener(Event.CHANGE,this.changeRoom);
                  this.Application.rooms_lb.addItem({"label":"Cargando Salas..."});
                  this.EncryptStringRijndael55(this.myIP);
                  this.tracker.trackPageview("WELCOME TO CHATVIDEO!");
                  this.firstLogon = false;
                  if(this.myGender == "female")
                  {
                     this.startCam();
                  }
               }
               this.isConnected = true;
               this.Application.people_lb.removeAll();
               this.Application.people_lb.addItem({"label":"Cargando..."});
               this.login_mc.conn_anim.visible = false;
               this.login_mc.server_msg.text = "";
               this.login_mc.visible = false;
               this.Application.visible = true;
               this.changingRoom = false;
               this.manageStreams();
               if(this.sending_video)
               {
                  this.tracker.trackPageview("RE_INIT_CAM_ROOM_CHANGE");
                  this.startCam();
               }
               return;
            case "NetConnection.Connect.Failed":
               this.showAlerts("Conexion fallida con el servidor, Intenta nuevamente!");
               this.login_mc.conn_anim.visible = false;
               this.login_mc.server_msg.text = "";
               this.login_mc.login_btn.enabled = true;
               this.soTimer24.stop();
               this.isConnected = false;
               this.countryConn = true;
               this.tracker.trackPageview("NetConnection.Connect.Failed");
               break;
            case "NetConnection.Connect.Closed":
               if(this.changingRoom)
               {
                  break;
               }
               this.showAlerts("<br><br>Conection closed!<br><br>");
               return;
            case "NetConnection.Connect.Rejected":
               this.rejected = true;
               this.isConnected = false;
               this.countryConn = true;
               if(param1.info.application.msg == "Todos los espacios libres estan ocupados, Registrate para acceso inmediato!")
               {
                  this.tracker.trackPageview("Lobby Full, Try Again");
                  this.nc.close();
                  this.login_mc.login_btn.enabled = true;
                  this.login_mc.conn_anim.visible = false;
                  this.login_mc.visible = true;
                  this.Application.visible = false;
                  this.login_mc.server_msg.text = param1.info.application.msg;
                  return;
               }
               this.showAlerts("\nConexión rechazada por el servidor\n\n" + param1.info.application.msg);
               this.login_mc.login_btn.enabled = true;
               this.login_mc.conn_anim.visible = false;
               this.login_mc.visible = true;
               this.Application.visible = false;
               this.tracker.trackPageview("Conn Rejected, Reason: " + param1.info.application.msg);
               this.login_mc.server_msg.text = param1.info.application.msg;
               this.roomID = this.lobbyID;
               this.nc.close();
               return;
         }
      }
      
      public function showAlerts2(param1:String, param2:String) : void
      {
         this.inviteSender = param1;
         this.inviteSenderIP = param2;
         this.showAlerts("\n\n" + param1 + "\nTe ha invitado a una sala privada...");
         this.alertW.ok_but.visible = false;
         this.alertW.accept_but.visible = true;
         this.alertW.deny_but.visible = true;
      }
      
      public function showRegAlert(param1:String) : void
      {
      }
      
      function regAlertResponse(param1:Event) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.chatvideo.es/reg.html");
         navigateToURL(_loc2_,"_blank");
         this.tracker.trackPageview("REGISTER_URL_CLICKED");
      }
      
      public function imHere(param1:*) : *
      {
         return true;
      }
      
      public function serverMsg9(param1:String, param2:String) : void
      {
         if(this.Application.optionsMC.avisos.selected == false)
         {
            return;
         }
         var _loc3_:* = "<font face=\'Tahoma\' size=\'12\' color=\"" + param2 + "\">" + param1 + "</font>";
         this.messages.push({"chatMsg":_loc3_});
         this.displayMessages();
      }
      
      public function serverMsg(param1:String, param2:String) : void
      {
         var _loc3_:* = "<font face=\'Arial\' size=\'12\' color=\"" + param2 + "\">" + param1 + "</font>";
         this.messages.push({"chatMsg":_loc3_});
         this.displayMessages();
      }
      
      public function receiveMessage(param1:String, param2:String, param3:String) : void
      {
         if(this.Application.optionsMC.pvCheck.selected == false)
         {
            this.nc.call("IgnoUser2",null,param2,this.myName);
            this.tracker.trackPageview("RECEIVE_PV_OFF");
            return;
         }
         var _loc4_:* = 0;
         while(_loc4_ < this.ignoredPPL.length)
         {
            if(this.ignoredPPL[_loc4_] == param3)
            {
               this.tracker.trackPageview("USER_IGNORED_DON\'T_SHOW_PV_MSG");
               return;
            }
            _loc4_++;
         }
         if(this.bellSound == true)
         {
            this.tracker.trackPageview("PLAY_PV_SOUND");
            this.myBell.play();
         }
         this.tracker.trackPageview("PV MSG RECEIVED!");
         this.messages.push({"chatMsg":param1});
         this.displayMessages();
      }
      
      public function ignoredMe2(param1:String) : void
      {
         var _loc2_:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + param1 + " no acepta mensajes privados</font>";
         this.messages.push({"chatMsg":_loc2_});
         this.displayMessages();
         this.tracker.trackPageview("NOT ACCEPTING PM");
      }
      
      public function receiveAdminMessage(param1:String) : void
      {
         this.messages.push({"chatMsg":param1});
         this.displayMessages();
      }
      
      public function receiveHistory(param1:String) : void
      {
         this.messages.splice(0);
         this.Application.History.text = "";
      }
      
      public function receiveTimeOut(param1:String) : void
      {
         if(this.myGender == "female" && this.sending_video == true)
         {
            return;
         }
         if(this.timeWatched > this.maxCamVtime)
         {
            this.mainTimeOut();
            this.tracker.trackPageview("GENERAL TIMEOUT SENT FROM ADMIN");
         }
      }
      
      public function setCountry(param1:String) : void
      {
         this.myIP = "27.17.51.15";
         this.sendRealIP(this.myIP);
         this.tracker.trackPageview("setCountry();");
      }
      
      public function setRoomNameAndID(param1:String, param2:String) : void
      {
         var _loc3_:* = "<font face=\'Arial\' color=\'#000000\' size=\'12\'>Bienvenido a la sala <font color=\'#FF0000\'>" + param1 + "</font>";
         this.tracker.trackPageview("Room Name: " + param1);
         if(this.doOnceTimers == true)
         {
            this.Application.msg.setStyle("textFormat",this.formatMsg);
            this.soTimer24.start();
            this.doOnceTimers = false;
         }
         this.currentRoomID = param2;
         this.roomTitle = param1;
         this.Application.chat_title.text = "Chat en " + param1;
         this.messages.push({"chatMsg":_loc3_});
         this.displayMessages();
      }
      
      public function onRoomownerauth() : void
      {
         var iBanUser:Function = null;
         iBanUser = function(param1:MouseEvent):void
         {
            var _loc2_:* = theWho;
            if(_loc2_ != undefined)
            {
               nc.call("BanUser",null,_loc2_,myName);
            }
         };
         if(this.isVip == true)
         {
            var kickUser:Function = function(param1:MouseEvent):void
            {
               var _loc2_:* = theWho;
               if(_loc2_ != undefined)
               {
                  nc.call("kickUser",null,_loc2_,myName);
               }
            };
            this.tracker.trackPageview("MY_ROOM_SHOW_MODTOOLS!");
            this.Application.modTools.visible = true;
            if(this.sendRoomKey != "")
            {
               this.nc.call("setRoomKey",null,this.sendRoomKey,this.myName);
            }
            if(this.firstOwnerAuth)
            {
               this.Application.modTools.kick_bt.addEventListener(MouseEvent.CLICK,kickUser);
               this.Application.modTools.ban_bt.addEventListener(MouseEvent.CLICK,iBanUser);
               this.firstOwnerAuth = false;
            }
         }
      }
      
      public function inviteME(param1:String, param2:String) : void
      {
         this.tracker.trackPageview("PV INVIT RECEIVED");
         var _loc3_:* = 0;
         while(_loc3_ < this.ignoredPPL.length)
         {
            if(this.ignoredPPL[_loc3_] == param2)
            {
               this.tracker.trackPageview("Ignored user, don\'t show his invitation");
               return;
            }
            _loc3_++;
         }
         if(this.Application.optionsMC.invCheck.selected != true)
         {
            return;
         }
         this.showAlerts2(param1,param2);
      }
      
      function ignoreLink(param1:TextEvent) : void
      {
         this.ignoreUser(param1.text);
         this.tracker.trackPageview("IGNORE CLICKED");
      }
      
      public function ignoreUser(param1:*) : void
      {
         var _loc2_:String = param1;
         var _loc3_:Array = _loc2_.split(",");
         var _loc4_:* = 0;
         var _loc5_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'>* " + _loc3_[0] + " ha sido ignorad@";
         this.messages.push({"chatMsg":_loc5_});
         this.displayMessages();
         var _loc6_:* = _loc3_[0];
         var _loc7_:* = this.myName;
         this.ignoredPPL.push(_loc3_[1]);
         this.nc.call("IgnoUser",null,_loc6_,_loc7_);
      }
      
      public function ignoredMe(param1:String) : void
      {
      }
      
      public function floodBan(param1:String) : void
      {
      }
      
      public function flagMe(param1:String) : void
      {
      }
      
      public function onAdminauth() : void
      {
      }
      
      public function setVotesNumber(param1:String) : void
      {
         this.Application.myCamMC.likesText.text = param1;
         this.local_so.data.myVotes = param1;
         this.local_so.flush();
      }
      
      public function roomDeleted() : void
      {
         this.tracker.trackPageview("room_Deleted,_closing_connection");
         this.showAlerts("\nLa sala ha finalizado sesión\nHas ingresado a Lobby");
         this.roomID = this.lobbyID;
         this.changingRoom = true;
         this.doDisconnect();
         this.connectApp();
      }
      
      public function globalMsg(param1:String) : void
      {
      }
      
      public function onReceiveMsgMobile(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
      }
      
      public function close() : void
      {
      }
      
      public function onReceiveMsg(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:String = null;
         if(param2 != param5)
         {
            return;
         }
         var _loc7_:* = 0;
         while(_loc7_ < this.ignoredPPL.length)
         {
            if(this.ignoredPPL[_loc7_] == param4)
            {
               this.tracker.trackPageview("IGNORED_USER_DON\'T_DISPLAY_MESSAGE");
               return;
            }
            _loc7_++;
         }
         _loc6_ = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><b><font face=\'Tahoma\' size=\'14\' color=\'#FF7004\'> " + param2 + ": </font></b>" + param1;
         this.messages.push({"chatMsg":_loc6_});
         this.displayMessages();
      }
      
      public function onReceiveMsgUser(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:String = null;
         if(param2 != param5)
         {
            return;
         }
         var _loc7_:* = 0;
         while(_loc7_ < this.ignoredPPL.length)
         {
            if(this.ignoredPPL[_loc7_] == param4)
            {
               this.tracker.trackPageview("IGNORED_USER_DON\'T_DISPLAY_MESSAGE");
               return;
            }
            _loc7_++;
         }
         var param1:String = param1.toLowerCase();
         if(param2 == this.myName)
         {
            _loc6_ = "<b><font face=\'Tahoma\' size=\'15\' color=\'#000000\'> " + param2 + ": </font></b>" + param1;
         }
         else
         {
            _loc6_ = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><font face=\'Tahoma\' size=\'14\' color=\'#002A45\'><b> " + param2 + ": </b></font><font size=\'13\'>" + param1;
         }
         this.messages.push({"chatMsg":_loc6_});
         this.displayMessages();
      }
      
      function frame1() : *
      {
         stop();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         this.addEventListener(Event.ENTER_FRAME,this.loading);
      }
      
      function frame2() : *
      {
         stop();
         this.myBell = new Sound();
         this.xmlLoader = new URLLoader();
         this.xmlLoader.addEventListener(Event.COMPLETE,this.loadXML);
         this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.loaderMissing);
         this.xmlData = new XML();
         this.xmlFile = "v20.xml" + "?" + Math.random();
         this.xmlLoader.load(new URLRequest(this.xmlFile));
         this.url = "http://chatvideo.es/local_as3.php";
         this.bf = new BlurFilter(5,5,5);
         this.enterRoomMC.visible = false;
         this.enterRoomMC.badpwd.visible = false;
         this.login_mc.conn_anim.visible = false;
         this.Application.bigRegister.visible = false;
         this.Application.visible = false;
         this.newRmc.visible = false;
         this.myColor = "#C0C0C0";
         this.fmt = new TextFormat();
         this.fmt.font = "Tahoma";
         this.fmt.color = 14449707;
         this.fmt.size = "18";
         this.fmt.bold = true;
         this.fmtRoomList = new TextFormat();
         this.fmtRoomList.font = "Tahoma";
         this.fmtRoomList.color = 10066329;
         this.fmtRoomList.size = "16";
         this.fmtRoomList.bold = true;
         this.Application.people_lb.setRendererStyle("textFormat",this.fmt);
         this.Application.rooms_lb.setRendererStyle("textFormat",this.fmtRoomList);
         this.Application.people_lb.rowHeight = 28;
         this.Application.rooms_lb.rowHeight = 25;
         this.Application.option_bt.setStyle("icon",settings_graphic);
         this.Application.cam1.likeCam.setStyle("icon",like_graphic);
         this.Application.cam1.likeCam.setStyle("textPadding",0);
         this.Application.cam1.flag_bt.setStyle("icon",warning_graphic);
         this.Application.cam1.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.mensPv.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.optionsMC.cam_conf_bt.setStyle("icon",webcam_graphic);
         this.Application.optionsMC.close_opt.setStyle("icon",check_graphic);
         this.Application.create_pb.setStyle("icon",add_graphic);
         this.Application.logout_bt.setStyle("icon",logout_graphic);
         this.formatMsg = new TextFormat();
         this.formatMsg.font = "Verdana";
         this.formatMsg.color = 3355443;
         this.formatMsg.size = "15";
         this.formatMsg.bold = true;
         this.formatMsg.italic = false;
         this.formatMsg.underline = false;
         this.formatRMsg = new TextFormat();
         this.formatRMsg.font = "Tahoma";
         this.formatRMsg.color = 16711680;
         this.formatRMsg.size = "15";
         this.formatRMsg.bold = true;
         this.formatRMsg2 = new TextFormat();
         this.formatRMsg2.font = "Tahoma";
         this.formatRMsg2.color = 0;
         this.formatRMsg2.size = "13";
         this.formatRMsg2.bold = true;
         this.newRmc.newRN.setStyle("textFormat",this.formatRMsg);
         this.newRmc.newRD.setStyle("textFormat",this.formatRMsg);
         this.newRmc.newRP.setStyle("textFormat",this.formatRMsg);
         this.newRmc.newRV.setStyle("textFormat",this.formatRMsg);
         this.newRmc.newR_ok_pb.setStyle("textFormat",this.formatRMsg2);
         this.newRmc.newRcancel_pb.setStyle("textFormat",this.formatRMsg2);
         this.enterRoomMC.claveSala.setStyle("textFormat",this.formatRMsg);
         this.alertW.accept_but.setStyle("textFormat",this.formatRMsg2);
         this.alertW.deny_but.setStyle("textFormat",this.formatRMsg2);
         this.alertW.ok_but.setStyle("textFormat",this.formatRMsg2);
         this.formatPVMsg = new TextFormat();
         this.formatPVMsg.font = "Tahoma";
         this.formatPVMsg.color = 16711680;
         this.formatPVMsg.size = "16";
         this.formatPVMsg.bold = true;
         this.loginFormat = new TextFormat();
         this.loginFormat.font = "Tahoma";
         this.loginFormat.color = 255;
         this.loginFormat.size = "22";
         this.loginFormat.bold = true;
         this.loginFormat2 = new TextFormat();
         this.loginFormat.font = "Tahoma";
         this.loginFormat2.color = 3355443;
         this.loginFormat2.size = "15";
         this.loginFormat2.bold = true;
         this.startCamFormat = new TextFormat();
         this.startCamFormat.font = "Tahoma";
         this.startCamFormat.color = 0;
         this.startCamFormat.size = "12";
         this.startCamFormat.bold = true;
         this.likesCam1Format = new TextFormat();
         this.likesCam1Format.font = "Tahoma";
         this.likesCam1Format.color = 0;
         this.likesCam1Format.size = "12";
         this.likesCam1Format.bold = true;
         this.Application.cam1.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.Application.cam2.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.Application.cam3.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.Application.activateCam.setStyle("textFormat",this.startCamFormat);
         this.Application.activateMic.setStyle("textFormat",this.startCamFormat);
         this.optionsFormat = new TextFormat();
         this.optionsFormat.font = "Tahoma";
         this.optionsFormat.color = 3355443;
         this.optionsFormat.size = "12";
         this.optionsFormat.bold = true;
         this.Application.optionsMC.vipCheck.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.pvCheck.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.invCheck.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.avisos.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.bellCheck.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.close_opt.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.cam_conf_bt.setStyle("textFormat",this.optionsFormat);
         this.Application.bigRegister.bigLink.setStyle("textFormat",this.startCamFormat);
         this.Application.bigRegister.closeLink.setStyle("textFormat",this.startCamFormat);
         this.Application.mensPv.pv_msg.setStyle("textFormat",this.formatPVMsg);
         this.Application.mensPv.pv_msg.condenseWhite = true;
         this.Application.msg.setStyle("textFormat",this.formatMsg);
         this.login_mc.login_btn.setStyle("textFormat",this.loginFormat2);
         this.login_mc.login_name.setStyle("textFormat",this.loginFormat);
         this.login_mc.age_box.textField.setStyle("textFormat",this.loginFormat2);
         this.login_mc.age_box.dropdown.setRendererStyle("textFormat",this.loginFormat2);
         this.Application.msg.condenseWhite = true;
         this.login_mc.login_name.condenseWhite = true;
         this.Application.b_bt.addEventListener(MouseEvent.CLICK,this.doBold);
         this.Application.i_bt.addEventListener(MouseEvent.CLICK,this.doItalic);
         this.Application.u_bt.addEventListener(MouseEvent.CLICK,this.doUnderline);
         this.Application.colorPick.addEventListener(ColorPickerEvent.CHANGE,this.changeHandler);
         this.Application.fontSel.addEventListener(Event.CHANGE,this.changeFont);
         this.Application.fontSize_bt.addEventListener(MouseEvent.CLICK,this.changeFontSize);
         this.Application.fontType_bt.addEventListener(MouseEvent.CLICK,this.showFonts);
         this.textFilter = new GlowFilter();
         this.textFilter.blurX = this.textFilter.blurY = 3;
         this.textFilter.strength = 2;
         this.textFilter.color = 3355443;
         this.Application.cam1.cam1_txt.filters = [this.textFilter];
         this.Application.cam2.camname.filters = [this.textFilter];
         this.Application.cam3.camname.filters = [this.textFilter];
         this.Application.myCamMC.myName.filters = [this.textFilter];
         this.Application.myCamMC.likesText.filters = [this.textFilter];
         this.Application.fontSel.visible = false;
         this.Application.cam1.close_bt.addEventListener(MouseEvent.CLICK,this.cierraCam);
         this.Application.sort_bt.addEventListener(MouseEvent.CLICK,this.sortPeople);
         this.Application.bigRegister.bigLink.addEventListener(MouseEvent.CLICK,this.regCLickURL);
         this.Application.bigRegister.closeLink.addEventListener(MouseEvent.CLICK,this.closeCLick);
         this.Application.fullScreen_bt.addEventListener(MouseEvent.CLICK,this._handleClick);
         this.fontSelFormat = new TextFormat();
         this.fontSelFormat.font = "Tahoma";
         this.fontSelFormat.color = 3355443;
         this.fontSelFormat.size = "14";
         this.fontSelFormat.bold = true;
         this.Application.fontSel.setRendererStyle("textFormat",this.fontSelFormat);
         this.Application.fontSel.rowHeight = 25;
         this.Application.fontSel.addItem({"label":"Arial"});
         this.Application.fontSel.addItem({"label":"Courier New"});
         this.Application.fontSel.addItem({"label":"Calibri"});
         this.Application.fontSel.addItem({"label":"Courier New"});
         this.Application.fontSel.addItem({"label":"Franklin Gothic Medium"});
         this.Application.fontSel.addItem({"label":"Georgia"});
         this.Application.fontSel.addItem({"label":"Kartika"});
         this.Application.fontSel.addItem({"label":"MS Serif"});
         this.Application.fontSel.addItem({"label":"MV Boli"});
         this.Application.fontSel.addItem({"label":"Palatino Linotype, Book Antiqua"});
         this.Application.fontSel.addItem({"label":"Tahoma"});
         this.Application.fontSel.addItem({"label":"Trebuchet MS"});
         this.Application.fontSel.addItem({"label":"Verdana"});
         this.Application.fontSel.addItem({"label":"Westminster"});
         this.Application.option_bt.addEventListener(MouseEvent.CLICK,this.showOptionsPanel);
         this.Application.optionsMC.close_opt.addEventListener(MouseEvent.CLICK,this.closeOptionsPanel);
         this.login_mc.server_msg.visible = false;
         this.login_mc.login_btn.addEventListener(MouseEvent.CLICK,this.loginUser);
         this.genderGroup = new RadioButtonGroup("genderRadio");
         this.login_mc.maleRadio.addEventListener(MouseEvent.CLICK,this.announceCurrentGroup);
         this.login_mc.femaleRadio.addEventListener(MouseEvent.CLICK,this.announceCurrentGroup);
         this.reportedPPL = new Array();
         this.rijndael_key5 = "79566214843925";
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.CLICK,this.reportUser);
         this.Application.cam1.visible = false;
         this.timeWatched = 0;
         this.bigCamTimer = new Timer(1000,this.freeCamTimeN);
         this.bigCamTimer.addEventListener(TimerEvent.TIMER,this.countdown);
         this.Application.cam1.volMC.muteIcon.visible = false;
         this.soundXForm = new SoundTransform();
         this.ctrlON = false;
         this.Application.cam1.addEventListener(MouseEvent.MOUSE_OVER,this.HandleMouseOver);
         this.Application.cam1.addEventListener(MouseEvent.MOUSE_OUT,this.HandleMouseOut);
         this.Application.cam1.underbutt.visible = false;
         this.Application.cam1.volMC.volSlide.addEventListener(SliderEvent.CHANGE,this.volChange);
         this.curSelectionUser = null;
         this.doSyncOnce = true;
         this.uCounter = 0;
         this.uCounterCurrent = 0;
         this.mobileStream = false;
         this.Application.History.addEventListener(TextEvent.LINK,this.ignoreLink);
         this.updateTimer = new Timer(2000,1);
         this.updateTimer.addEventListener(TimerEvent.TIMER,this.onTimeUp);
         this.updateTimer67 = new Timer(2000);
         this.updateTimer67.addEventListener(TimerEvent.TIMER,this.onTimeUp888);
         this.Application.mensPv.visible = false;
         this.usersDP = new DataProvider();
         this.Application.people_lb.dataProvider = this.usersDP;
         this.Application.people_lb.iconFunction = this.determineIcon;
         this.Application.people_lb.addEventListener(Event.CHANGE,this.selectedUser);
         this.roomsDP = new DataProvider();
         this.Application.rooms_lb.dataProvider = this.roomsDP;
         this.Application.mensPv.sendPV_but.addEventListener(MouseEvent.CLICK,this.doSendPV);
         this.sendMsgTimeOut = false;
         this.sendMsgTimer = new Timer(5000,1);
         this.sendMsgTimer.addEventListener(TimerEvent.TIMER,this.sendMsgTImerDone);
         this.badWords = new Array();
         this.badWordsLoader = new URLLoader();
         this.badWordsLoader.addEventListener(Event.COMPLETE,this.onLoaded);
         this.badWordsLoader.addEventListener(IOErrorEvent.IO_ERROR,this.badWordsError);
         this.badWordsLoader.load(new URLRequest("badWords.txt" + "?" + Math.random()));
         this.Application.msg.addEventListener(FocusEvent.FOCUS_IN,this.onTextSelect);
         this.Application.mensPv.pv_msg.addEventListener(FocusEvent.FOCUS_IN,this.onTextSelect);
         this.Application.send_pb.addEventListener(MouseEvent.CLICK,this.doSend);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         this.Application.mensPv.closePV_but.addEventListener(MouseEvent.CLICK,this.closePV);
         this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OVER,this.showCreateTip);
         this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OUT,this.hideCreateTip);
         this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showInviteTip);
         this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideInviteTip);
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showFlagTip);
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideFlagTip);
         this.Application.people_lb.addEventListener(ListEvent.ITEM_ROLL_OVER,this.showUserInfo);
         this.Application.people_lb.addEventListener(ListEvent.ITEM_ROLL_OUT,this.hideUserInfo);
         this.Application.rooms_lb.addEventListener(ListEvent.ITEM_ROLL_OVER,this.showRoomInfo);
         this.Application.rooms_lb.addEventListener(ListEvent.ITEM_ROLL_OUT,this.hideUserInfo);
         this.Application.logout_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showLogout);
         this.Application.logout_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideLogout);
         this.myTimer = new Timer(1000,1);
         this.myTimer.addEventListener(TimerEvent.TIMER,this.hideIgnoTip);
         this.h264Config = new H264VideoStreamSettings();
         this.mic_on = false;
         this.camTimeUp = false;
         this.Application.myCamMC.visible = false;
         this.Application.optionsMC.visible = false;
         this.Application.optionsMC.bellOff.visible = false;
         this.Application.myCamMC.micVol.visible = false;
         this.Application.myCamMC.micIcon1.visible = false;
         this.Application.myCamMC.micMeter.visible = false;
         this.maleCamTimer = new Timer(1000,this.sendCamTimeN);
         this.maleCamTimer.addEventListener(TimerEvent.TIMER,this.countdown4);
         this.Application.myCamMC.micVol.addEventListener(SliderEvent.CHANGE,this.setMicLevel);
         this.Application.activateCam.addEventListener(MouseEvent.CLICK,this.cameraHandler);
         this.Application.optionsMC.bellCheck.addEventListener(MouseEvent.CLICK,this.bellHandler);
         this.Application.optionsMC.vipCheck.addEventListener(MouseEvent.CLICK,this.vipCamHandler);
         this.Application.activateMic.addEventListener(MouseEvent.CLICK,this.micHandler);
         this.badCamsLoader.addEventListener(Event.COMPLETE,this.onBadCamsLoaded);
         this.badCamsLoader.addEventListener(IOErrorEvent.IO_ERROR,this.badCamsError);
         this.badCamsLoader.load(new URLRequest("badCams.txt" + "?" + Math.random()));
         this.fakeTimer = new Timer(3000,0);
         this.fakeTimer.addEventListener(TimerEvent.TIMER,this.fakeTick);
         this.Application.optionsMC.cam_conf_bt.addEventListener(MouseEvent.CLICK,this.showCamConf);
         this.Application.logout_bt.addEventListener(MouseEvent.CLICK,this.doLogout);
         this.rijndael_key = "pZwq50ol87t";
         this.myRoomPW = "";
         this.sendRoomKey = "";
         this.newRmc.newR_ok_pb.addEventListener(MouseEvent.CLICK,this.createNR);
         this.newRmc.newRcancel_pb.addEventListener(MouseEvent.CLICK,this.closeNR);
         this.newRmc.newRN.tabIndex = 1;
         this.newRmc.newRD.tabIndex = 2;
         this.newRmc.newRP.tabIndex = 3;
         this.newRmc.roomLimite.tabIndex = 4;
         this.newRmc.newRV.tabIndex = 5;
         this.newRmc.newR_ok_pb.tabIndex = 6;
         this.newRmc.newRcancel_pb.tabIndex = 7;
         this.Application.create_pb.addEventListener(MouseEvent.CLICK,this.createRoomHandler);
         this.enterRoomMC.entrar_bt.addEventListener(MouseEvent.CLICK,this.enterPWroom);
         this.enterRoomMC.cancelar_bt.addEventListener(MouseEvent.CLICK,this.enterPWroomClose);
         this.sendInvitation = true;
         this.Application.cam1.invite_bt.addEventListener(MouseEvent.CLICK,this.runInvite);
         this.Application.mensPv.invite_bt.addEventListener(MouseEvent.CLICK,this.runInvite4);
         this.timeOut88 = new Timer(2000,1);
         this.timeOut88.addEventListener(TimerEvent.TIMER,this.tempo66Expired);
         this.imgLoad = false;
         this.imgLoad2 = false;
         this.imgLoad3 = false;
         this.local_so = SharedObject.getLocal("chatvideoSept10","/");
         if(this.local_so.data.myName != undefined)
         {
            this.login_mc.login_name.text = this.local_so.data.myName;
            this.myColorX = this.local_so.data.myColor;
            this.formatMsg.font = this.local_so.data.myFontType;
            this.formatMsg.color = this.local_so.data.myColor;
            this.formatMsg.bold = this.local_so.data.myFontBold;
            this.formatMsg.italic = this.local_so.data.myFontItalic;
            this.Application.msg.setStyle("textFormat",this.formatMsg);
            this.loginFormat.color = this.local_so.data.myColor;
            this.login_mc.login_name.setStyle("textFormat",this.loginFormat);
            this.camIgnoringMe = this.local_so.data.storedArray;
            this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
         }
         if(this.local_so.data.myVotes == undefined)
         {
            this.local_so.data.myVotes = 0;
            this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
         }
         if(this.local_so.data.isBanned == undefined)
         {
            this.local_so.data.isBanned = false;
         }
         if(this.local_so.data.camOff == undefined)
         {
            this.local_so.data.camOff = false;
         }
         this.soTimer24 = new Timer(10000,0);
         this.soTimer24.addEventListener(TimerEvent.TIMER,this.onTick24);
         this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler4);
         this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler4);
         this.alertW.ok_but.addEventListener(MouseEvent.CLICK,this.closeAlerts);
         this.alertW.accept_but.addEventListener(MouseEvent.CLICK,this.inviteOnAccept);
         this.alertW.deny_but.addEventListener(MouseEvent.CLICK,this.inviteOnReject);
         this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser);
      }
      
      public var ActualName:String;
      
      public var ActualCountry:String;
      
      public var ActualAge:Number;
   }
}
