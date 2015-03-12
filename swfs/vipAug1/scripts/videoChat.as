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
   import flash.utils.Timer;
   import fl.controls.RadioButtonGroup;
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
   import com.myflashlab.classes.tools.infoBox.alert.AlertWindow;
   import flash.display.StageScaleMode;
   import com.myflashlab.classes.tools.infoBox.alert.AlertEvents;
   import com.google.analytics.GATracker;
   
   public class videoChat extends MovieClip
   {
      
      public function videoChat()
      {
         this.tracker = new GATracker(stage,"UA-6669334-2","AS3",false);
         this.bannedDevices = new Array();
         this.badCamsLoader = new URLLoader();
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
      
      public var vipUser:String;
      
      public var sound1:String;
      
      public var myBell:Sound;
      
      public var xmlLoader:URLLoader;
      
      public function loaderMissing(param1:IOErrorEvent) : void
      {
         this.tracker.trackPageview("XML ERROR, IS  YOUR XML FILE THERE?");
         this.showAlerts("<br><br>Error XML, Te recomendamos borrar el cache<br>de tu navegador y recargar la pagina.<br>");
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
         this.sound1 = this.xmlData.chatConfig.pvSound.text();
         this.myBell.load(new URLRequest(this.sound1));
         this.lobbyID = this.roomID;
      }
      
      public var xmlFile;
      
      public var request:URLRequest;
      
      public var VIPloader:URLLoader;
      
      public function loaderMissing2(param1:IOErrorEvent) : void
      {
         this.tracker.trackPageview("Error Loading VIP Username");
         this.showAlerts("<br><br>Error al obtener nombre de usuario<br>Por favor reinicia la página.<br><br> ");
         this.login_mc.login_btn.enabled = false;
         this.login_mc.visible = false;
      }
      
      public function completeHandler(param1:Event) : *
      {
         this.vipUser = param1.target.data.username;
         this.login_mc.login_name.text = this.vipUser;
      }
      
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
      
      public var likesCam1Format:TextFormat;
      
      public var formatMsg:TextFormat;
      
      public var formatRMsg:TextFormat;
      
      public var formatRMsg2:TextFormat;
      
      public var formatPVMsg:TextFormat;
      
      public var loginFormat:TextFormat;
      
      public var loginFormat2:TextFormat;
      
      public var startCamFormat:TextFormat;
      
      public var optionsFormat:TextFormat;
      
      public function doBold(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("boldFontClicked");
         if(this.formatMsg.bold == false)
         {
            this.formatMsg.bold = true;
            this.local_so.data.myFontBold = true;
         }
         else
         {
            this.formatMsg.bold = false;
            this.local_so.data.myFontBold = false;
         }
         this.Application.msg.setStyle("textFormat",this.formatMsg);
      }
      
      public function doUnderline(param1:MouseEvent) : void
      {
         if(this.formatMsg.underline == false)
         {
            this.formatMsg.underline = true;
         }
         else
         {
            this.formatMsg.underline = false;
         }
         this.Application.msg.setStyle("textFormat",this.formatMsg);
      }
      
      public function doItalic(param1:MouseEvent) : void
      {
         this.tracker.trackPageview("ItalicFontClicked");
         if(this.formatMsg.italic == false)
         {
            this.formatMsg.italic = true;
            this.local_so.data.myFontItalic = true;
         }
         else
         {
            this.formatMsg.italic = false;
            this.local_so.data.myFontItalic = false;
         }
         this.Application.msg.setStyle("textFormat",this.formatMsg);
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
         if(this.formatMsg.size == "13")
         {
            this.formatMsg.size = "14";
            this.local_so.data.myFontSize = "14";
         }
         else
         {
            this.formatMsg.size = "13";
            this.local_so.data.myFontSize = "13";
         }
         this.Application.msg.setStyle("textFormat",this.formatMsg);
      }
      
      public function changeFont(param1:Event) : void
      {
         this.formatMsg.font = this.Application.fontSel.selectedItem.label;
         this.Application.msg.setStyle("textFormat",this.formatMsg);
         this.Application.fontSel.visible = false;
         this.tracker.trackPageview("SELECTED_FONT:_" + this.Application.fontSel.selectedItem.label);
         this.local_so.data.myFontType = this.Application.fontSel.selectedItem.label;
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
            _loc2_ = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>Debes ser usuario <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrado</a></u></font> para ver pantalla completa.</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc2_;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
      
      public var killTimer:Timer;
      
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
      }
      
      public var reportedPPL;
      
      public var rijndael_key5:String;
      
      public function reportUser(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam1.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc2_ + " ha sido reportad@ como inapropiad@</font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.Application.myTooltip2.hide();
         this.reportedPPL.push(_loc2_);
         this.tracker.trackPageview("User Flagged");
         this.nc.call("flagThis",null,_loc2_,this.myIP);
         this.Application.cam1.flag_bt.enabled = false;
      }
      
      public function reportUser2(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam2.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc2_ + " ha sido reportad@ como inapropiad@</font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.Application.myTooltip2.hide();
         this.reportedPPL.push(_loc2_);
         this.tracker.trackPageview("User Flagged");
         this.nc.call("flagThis",null,_loc2_,this.myIP);
         this.Application.cam2.flag_bt.enabled = false;
      }
      
      public function reportUser3(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam3.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc2_ + " ha sido reportad@ como inapropiad@</font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.Application.myTooltip2.hide();
         this.reportedPPL.push(_loc2_);
         this.tracker.trackPageview("User Flagged");
         this.nc.call("flagThis",null,_loc2_,this.myIP);
         this.Application.cam3.flag_bt.enabled = false;
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
      
      public var soundXForm:SoundTransform;
      
      public var soundXForm2:SoundTransform;
      
      public var soundXForm3:SoundTransform;
      
      public var publish_ns:NetStream;
      
      public var play_ns:NetStream;
      
      public var play_ns2:NetStream;
      
      public var play_ns3:NetStream;
      
      public var mobileStream:Boolean;
      
      public var ctrlON:Boolean;
      
      public function closecam1() : *
      {
         this.play_ns.close();
         this.receiving_video = false;
         this.Application.cam1.visible = false;
         this.Application.cam1.cam1_wtxt.text = "";
         this.nc.call("watchingWho",null,null);
      }
      
      public function closecam2() : *
      {
         this.play_ns2.close();
         this.receiving_video2 = false;
         this.Application.cam2.visible = false;
         this.Application.cam2.camname.text = "";
         this.Application.cam2.cam1_wtxt.text = "";
      }
      
      public function closecam3() : *
      {
         this.play_ns3.close();
         this.receiving_video3 = false;
         this.Application.cam3.visible = false;
         this.Application.cam3.camname.text = "";
         this.Application.cam3.cam1_wtxt.text = "";
      }
      
      public function manageStreams() : void
      {
         this.publish_ns = new NetStream(this.nc);
         this.play_ns = new NetStream(this.nc);
         this.play_ns.addEventListener(NetStatusEvent.NET_STATUS,this.videoStatusEvent);
         this.play_ns.client = this;
         this.play_ns2 = new NetStream(this.nc);
         this.play_ns2.addEventListener(NetStatusEvent.NET_STATUS,this.videoStatusEvent2);
         this.play_ns2.client = this;
         this.play_ns3 = new NetStream(this.nc);
         this.play_ns3.addEventListener(NetStatusEvent.NET_STATUS,this.videoStatusEvent3);
         this.play_ns3.client = this;
      }
      
      public function videoStatusEvent(param1:Object) : void
      {
         if(param1.info.code == "NetStream.Buffer.Full")
         {
            this.soundXForm.volume = this.Application.cam1.volMC.volSlide.value;
            this.Application.cam1.load_anim.visible = false;
         }
         else if(param1.info.code == "NetStream.Play.Reset")
         {
            this.Application.cam1.video1.clear();
            this.Application.cam1.load_anim.visible = true;
            this.Application.cam1.flag_bt.enabled = true;
            this.Application.cam1.likeCam.enabled = true;
            this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser);
         }
         else if(param1.info.code == "NetStream.Play.UnpublishNotify")
         {
            this.closecam1();
         }
         else if(param1.info.code == "NetStream.Buffer.Empty")
         {
            this.Application.cam1.load_anim.visible = true;
         }
         
         
         
      }
      
      public function videoStatusEvent2(param1:Object) : void
      {
         if(param1.info.code == "NetStream.Buffer.Full")
         {
            this.soundXForm2.volume = this.Application.cam2.volMC.volSlide.value;
            this.Application.cam2.load_anim.visible = false;
         }
         else if(param1.info.code == "NetStream.Play.Reset")
         {
            this.Application.cam2.videoObject.clear();
            this.Application.cam2.load_anim.visible = true;
            this.Application.cam2.flag_bt.enabled = true;
            this.Application.cam2.likeCam.enabled = true;
            this.Application.cam2.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser2);
         }
         else if(param1.info.code == "NetStream.Play.UnpublishNotify")
         {
            this.closecam2();
         }
         else if(param1.info.code == "NetStream.Buffer.Empty")
         {
         }
         
         
         
      }
      
      public function videoStatusEvent3(param1:Object) : void
      {
         if(param1.info.code == "NetStream.Buffer.Full")
         {
            this.soundXForm3.volume = this.Application.cam3.volMC.volSlide.value;
            this.Application.cam3.load_anim.visible = false;
         }
         else if(param1.info.code == "NetStream.Play.Reset")
         {
            this.Application.cam3.videoObject.clear();
            this.Application.cam3.load_anim.visible = true;
            this.Application.cam3.flag_bt.enabled = true;
            this.Application.cam3.likeCam.enabled = true;
            this.Application.cam3.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser3);
         }
         else if(param1.info.code == "NetStream.Play.UnpublishNotify")
         {
            this.closecam3();
         }
         else if(param1.info.code == "NetStream.Buffer.Empty")
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
      
      public function HandleMouseOver2(param1:MouseEvent) : *
      {
         this.Application.cam2.volMC.visible = true;
         this.Application.cam2.close_bt.visible = true;
         this.Application.cam2.invite_bt.visible = true;
         this.Application.cam2.flag_bt.visible = true;
         this.Application.cam2.underbutt.visible = true;
         this.Application.cam2.likeCam.visible = true;
      }
      
      public function HandleMouseOut2(param1:MouseEvent) : *
      {
         this.Application.cam2.volMC.visible = false;
         this.Application.cam2.close_bt.visible = false;
         this.Application.cam2.invite_bt.visible = false;
         this.Application.cam2.flag_bt.visible = false;
         this.Application.cam2.underbutt.visible = false;
         this.Application.cam2.likeCam.visible = false;
      }
      
      public function HandleMouseOver3(param1:MouseEvent) : *
      {
         this.Application.cam3.volMC.visible = true;
         this.Application.cam3.close_bt.visible = true;
         this.Application.cam3.invite_bt.visible = true;
         this.Application.cam3.flag_bt.visible = true;
         this.Application.cam3.underbutt.visible = true;
         this.Application.cam3.likeCam.visible = true;
      }
      
      public function HandleMouseOut3(param1:MouseEvent) : *
      {
         this.Application.cam3.volMC.visible = false;
         this.Application.cam3.close_bt.visible = false;
         this.Application.cam3.invite_bt.visible = false;
         this.Application.cam3.flag_bt.visible = false;
         this.Application.cam3.underbutt.visible = false;
         this.Application.cam3.likeCam.visible = false;
      }
      
      public function playStream(param1:String, param2:String, param3:String) : void
      {
         this.nc.call("askCam",null,param1,this.myIPencrypted);
         if(this.receiving_video2 == true && this.receiving_video3 == true)
         {
            this.receiving_video = false;
         }
         if(this.receiving_video == false && !(param1 == this.Application.cam1.cam1_wtxt.text) && !(param1 == this.Application.cam2.cam1_wtxt.text) && !(param1 == this.Application.cam3.cam1_wtxt.text))
         {
            this.play_ns.close();
            this.nc.call("watchingWho",null,param1);
            if(this.imgLoad == true)
            {
               this.imageLoader.unload();
               this.Application.cam1.flagArea.removeChild(this.imageLoader);
               this.imgLoad = false;
            }
            if(param3 == "España")
            {
               var param3:* = "Spain";
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
            this.play_ns.bufferTime = 1;
            this.play_ns.play(param1);
            this.receiving_video = true;
            this.Application.cam1.cam1_txt.text = param1 + ", " + param2;
            this.Application.cam1.cam1_wtxt.text = param1;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.tracker.trackPageview("WATCHING STREAM: " + param1);
         }
         else if(this.receiving_video == true && !(param1 == this.Application.cam1.cam1_wtxt.text) && !(param1 == this.Application.cam2.cam1_wtxt.text) && !(param1 == this.Application.cam3.cam1_wtxt.text) && this.receiving_video2 == false)
         {
            this.play_ns2.close();
            this.receiving_video2 = true;
            this.Application.cam2.visible = true;
            this.Application.cam2.load_anim.visible = true;
            this.Application.cam2.cam1_wtxt.text = param1;
            if(this.imgLoad2 == true)
            {
               this.imageLoader2.unload();
               this.Application.cam2.flagArea.removeChild(this.imageLoader2);
               this.imgLoad2 = false;
            }
            if(param3 == "España")
            {
               param3 = "Spain";
            }
            this.loadImage2(param3);
            this.play_ns2.bufferTime = 1;
            this.play_ns2.soundTransform = this.soundXForm2;
            if(this.mobileStream)
            {
               this.Application.cam2.videoObject.visible = false;
               this.Application.cam2.videoObject2.visible = true;
               this.Application.cam2.videoObject2.attachNetStream(this.play_ns2);
            }
            if(!this.mobileStream)
            {
               this.Application.cam2.videoObject.visible = true;
               this.Application.cam2.videoObject2.visible = false;
               this.Application.cam2.videoObject.attachNetStream(this.play_ns2);
            }
            this.Application.cam2.camname.text = param1 + ", " + param2;
            this.play_ns2.play(param1);
         }
         else if(this.receiving_video2 == true && !(param1 == this.Application.cam1.cam1_wtxt.text) && !(param1 == this.Application.cam2.cam1_wtxt.text) && !(param1 == this.Application.cam3.cam1_wtxt.text) && this.receiving_video3 == false)
         {
            this.play_ns3.close();
            this.receiving_video3 = true;
            this.Application.cam3.visible = true;
            this.Application.cam3.load_anim.visible = true;
            this.Application.cam3.cam1_wtxt.text = param1;
            if(this.imgLoad3 == true)
            {
               this.imageLoader3.unload();
               this.Application.cam3.flagArea.removeChild(this.imageLoader3);
               this.imgLoad3 = false;
            }
            if(param3 == "España")
            {
               param3 = "Spain";
            }
            this.loadImage3(param3);
            this.play_ns3.bufferTime = 1;
            this.play_ns3.soundTransform = this.soundXForm3;
            if(this.mobileStream)
            {
               this.Application.cam3.videoObject.visible = false;
               this.Application.cam3.videoObject2.visible = true;
               this.Application.cam3.videoObject2.attachNetStream(this.play_ns3);
            }
            if(!this.mobileStream)
            {
               this.Application.cam3.videoObject.visible = true;
               this.Application.cam3.videoObject2.visible = false;
               this.Application.cam3.videoObject.attachNetStream(this.play_ns3);
            }
            this.Application.cam3.camname.text = param1 + ", " + param2;
            this.play_ns3.play(param1);
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
      
      public function volChange2(param1:SliderEvent) : void
      {
         if(param1.value == 0)
         {
            this.Application.cam2.volMC.muteIcon.visible = true;
         }
         else if(param1.value != 0)
         {
            this.Application.cam2.volMC.muteIcon.visible = false;
         }
         
         this.soundXForm2.volume = param1.value;
         this.play_ns2.soundTransform = this.soundXForm2;
      }
      
      public function volChange3(param1:SliderEvent) : void
      {
         if(param1.value == 0)
         {
            this.Application.cam3.volMC.muteIcon.visible = true;
         }
         else if(param1.value != 0)
         {
            this.Application.cam3.volMC.muteIcon.visible = false;
         }
         
         this.soundXForm3.volume = param1.value;
         this.play_ns3.soundTransform = this.soundXForm3;
      }
      
      public var curSelectionUser:String;
      
      public var tempPW:String;
      
      public var theWho:String;
      
      public var goingToRoom:String;
      
      public var globalMessage:String;
      
      public var doSyncOnce:Boolean;
      
      public var myIPencrypted:String;
      
      public var updateTimer:Timer;
      
      public function onTimeUp(param1:TimerEvent) : void
      {
         this.doSyncOnce = true;
      }
      
      public var updateTimer67:Timer;
      
      public function onTimeUp888(param1:TimerEvent) : void
      {
         this.updatePeopleList();
      }
      
      public function manageSO() : void
      {
         this.users_so = SharedObject.getRemote("users_so",this.nc.uri,false);
         this.chat_so = SharedObject.getRemote("chat_so",this.nc.uri,false);
         this.rooms_so = SharedObject.getRemote("public/roomsAndUsers",this.nc.uri,true);
         this.rooms_so.addEventListener(SyncEvent.SYNC,this.syncEventHandler);
         this.users_so.connect(this.nc);
         this.rooms_so.connect(this.nc);
         this.chat_so.connect(this.nc);
         this.chat_so.client = this;
         this.users_so.client = this;
         this.rooms_so.client = this;
         this.doSyncOnce = true;
         this.updateTimer67.start();
      }
      
      public var usersDP:DataProvider;
      
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
      
      public function updatePeopleList() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.usersDP.removeAll();
         for(_loc1_ in this.users_so.data)
         {
            if(this.users_so.data[_loc1_] != null)
            {
               _loc2_ = this.users_so.data[_loc1_];
               if(_loc2_.UserName == this.Application.cam1.cam1_wtxt.text)
               {
                  this.Application.cam1.likeCam.label = _loc2_.votesUp.toString();
               }
               if(_loc2_.UserName == this.Application.cam2.cam1_wtxt.text)
               {
                  this.Application.cam2.likeCam.label = _loc2_.votesUp.toString();
               }
               if(_loc2_.UserName == this.Application.cam3.cam1_wtxt.text)
               {
                  this.Application.cam3.likeCam.label = _loc2_.votesUp.toString();
               }
               if(this.Application.optionsMC.userCheck.selected == true)
               {
                  if(_loc2_.userstatus == "idle")
                  {
                     this.usersDP.addItem({
                        "label":_loc2_.UserName,
                        "data":_loc2_.UserName,
                        "gender":_loc2_.gender,
                        "streaming":_loc2_.userstatus,
                        "camtype":_loc2_.camtype,
                        "iswatching":_loc2_.iswatching,
                        "pais":_loc2_.pais,
                        "ip2":_loc2_.ip2,
                        "likes":_loc2_.votes,
                        "age":_loc2_.age,
                        "isMobile":_loc2_.mobileUser,
                        "vipCam":_loc2_.vipCam
                     });
                     this.usersDP.sortOn([this.listStatus,"gender","label"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
                  }
               }
               else
               {
                  this.usersDP.addItem({
                     "label":_loc2_.UserName,
                     "data":_loc2_.UserName,
                     "gender":_loc2_.gender,
                     "streaming":_loc2_.userstatus,
                     "camtype":_loc2_.camtype,
                     "iswatching":_loc2_.iswatching,
                     "pais":_loc2_.pais,
                     "ip2":_loc2_.ip2,
                     "likes":_loc2_.votes,
                     "age":_loc2_.age,
                     "isMobile":_loc2_.mobileUser,
                     "vipCam":_loc2_.vipCam
                  });
                  this.usersDP.sortOn([this.listStatus,"gender","label"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
               }
            }
         }
      }
      
      public var roomsDP:DataProvider;
      
      public function changeRoom(param1:Event) : void
      {
         var _loc2_:* = param1.target.selectedItem.data;
         this.roomID = _loc2_;
         var _loc3_:* = param1.target.selectedItem.lock;
         var _loc4_:* = param1.target.selectedItem.roomUserCount;
         var _loc5_:* = param1.target.selectedItem.vipRoom;
         this.goingToRoom = param1.target.selectedItem.nombre;
         var _loc6_:* = param1.target.selectedItem.roomLimit;
         var _loc7_:* = param1.target.selectedItem.owner;
         this.globalMessage = _loc7_;
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
         this.myAge = 30;
         this.myName = "COCO";
         this.myGender = "male";
         this.myCountry = "Lugano";
         if(_loc3_ == "94uwjjrs92845hwos083hj5w0eips0w4ji54st46464ss")
         {
            this.myName = "     ";
            this.myGender = "     ";
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
         this.nc.call("roomDest",null,this.goingToRoom);
         this.changingRoom = true;
         this.Application.people_lb.removeAll();
         this.Application.people_lb.addItem({"label":"Cargando.."});
         this.Application.History.htmlText = "";
         this.doDisconnect();
         this.tracker.trackPageview("Room Change To: " + this.goingToRoom);
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
         var _loc1_:* = this.Application.msg.htmlText;
         var _loc2_:* = this.Application.msg.text;
         if(_loc1_ != "")
         {
            this.nc.call("chatUser",null,_loc1_,this.myName,this.myColor,this.myIPencrypted,this.myName,_loc2_);
            this.Application.msg.text = "";
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         }
      }
      
      public function onTextSelect(param1:FocusEvent) : void
      {
         this.Application.fontSel.visible = false;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         this.closecam2();
         this.closecam3();
         this.closePVwin();
         this.nc.close();
      }
      
      public function selectedUser(param1:Event) : void
      {
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
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         if(this.curSelectionUser == this.myName)
         {
            this.theWho = undefined;
            this.closePVwin();
            return;
         }
         if(this.curSelectionUser == this.Application.cam1.cam1_wtxt.text)
         {
            this.Application.mensPv.visible = true;
            this.Application.History.y = 344;
            this.Application.History.height = 237;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
         }
         if(_loc2_ == "idle")
         {
            this.playStream(this.curSelectionUser,_loc3_,_loc4_);
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         if(this.timeOut == true)
         {
            this.tracker.trackPageview("StartCam Clicked but TimedOut :(");
            _loc2_ = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>Tu tiempo de videochat gratis ha terminado, <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Regístrate</a></u></font> para acceso sin límites!</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc2_;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.activateCam.selected = false;
            this.showRegAlert("Tu tiempo de videochat gratis ha terminado<br>Regístrate para acceso total!");
            return;
         }
         if(this.camTimeUp == true)
         {
            this.tracker.trackPageview("MALE SEND CAM TIMEUP");
            this.showRegAlert("Regístrate para activar tu camara sin límite de tiempo!");
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
         if(param1.target.selected == true)
         {
            this.tracker.trackPageview("USER SET WEBCAM TO VIP");
            this.nc.call("updatevipCamStatus",null,param1.target.selected);
         }
         else
         {
            this.nc.call("updatevipCamStatus",null,param1.target.selected);
         }
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
            this.mic.codec = SoundCodec.SPEEX;
            this.mic.enableVAD = false;
            this.mic.gain = this.Application.myCamMC.micVol.value;
            this.mic.encodeQuality = this.micQ;
            stage.addEventListener(Event.ENTER_FRAME,this.showLevel);
            this.mic_on = true;
            this.publish_ns.attachAudio(this.mic);
            this.tracker.trackPageview("MIC STARTED");
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
         this.Application.activateMic.enabled = false;
         this.Application.activateMic.selected = false;
         this.Application.activateCam.selected = false;
         this.Application.myCamMC.micVol.visible = false;
         this.Application.myCamMC.micIcon1.visible = false;
         this.Application.myCamMC.micMeter.visible = false;
      }
      
      public function startCam() : void
      {
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
            this.tracker.trackPageview("CAMERA FOUND: " + this.deviceName);
            this.cam.setQuality(this.camQ,0);
            this.cam.setMode(320,240,this.camFPS);
            this.cam.setKeyFrameInterval(48);
            this.Application.myCamMC.myCam.attachCamera(this.cam);
            this.Application.myCamMC.visible = true;
            this.publish_ns.attachCamera(this.cam);
            this.publish_ns.publish(this.myName,"live");
            this.Application.myCamMC.micMeter.visible = false;
            this.Application.activateMic.enabled = true;
            this.Application.activateCam.selected = true;
            this.nc.call("updatevipCamStatus",null,this.Application.optionsMC.vipCheck.selected);
            this.nc.call("updateCamStatus",null,this.deviceName);
            this.nc.call("updateStatus",null,"idle");
            this.nc.call("updateMyVotes",null,this.local_so.data.myVotes);
            this.sending_video = true;
            this.startMic();
            this.tracker.trackPageview("CAM STARTED");
            this.fakeTimer.start();
            if(this.cam.muted)
            {
               this.tracker.trackPageview("CAMERA IS MUTED, STOP BROADCAST");
               this.stopCam();
               Security.showSettings(SecurityPanel.PRIVACY);
            }
         }
         else
         {
            this.Application.History.htmlText = this.Application.History.htmlText + "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'><b>No se ha detectado cámara en tu ordenador, conecta una cámara e intenta de nuevo</b></font>";
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         if(this.timeOut == true)
         {
            this.stopCam();
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
               this.Application.History.htmlText = this.Application.History.htmlText + _loc6_;
               this.tracker.trackPageview("BANNED DEVICE: " + param1);
               this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         this.showAlerts("<br><br>Sesión Terminada.<br><br>");
      }
      
      public var rijndael_key:String;
      
      public var myRoomPW:String;
      
      public var sendRoomKey:String;
      
      public function createNR(param1:MouseEvent) : void
      {
         var i:* = undefined;
         var goNewRoom:Function = null;
         var roomObject:* = undefined;
         var roomErrMessg:* = undefined;
         var Event:MouseEvent = param1;
         goNewRoom = function():void
         {
            Application.History.htmlText = "";
            doDisconnect();
            connectApp();
         };
         if(this.newRmc.newRN.text == "")
         {
            this.newRmc.newRN.setFocus();
            return;
         }
         if(this.newRmc.newRD.text == "")
         {
            this.newRmc.newRD.setFocus();
            return;
         }
         if(this.newRmc.newRN.text == "Privado")
         {
            this.newRmc.newRN.setFocus();
            this.newRmc.newRN.text = "";
            return;
         }
         for(i in this.rooms_so.data)
         {
            if(this.rooms_so.data[i] != null)
            {
               roomObject = this.rooms_so.data[i];
               if(roomObject.owner == this.Eql9844kmgldiroURrX998q12Vgm)
               {
                  roomErrMessg = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'><i>Solamente se puede crear 1 sala por usuario.</i></font>";
                  this.Application.History.htmlText = this.Application.History.htmlText + roomErrMessg;
                  this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                  this.closeWinNR();
                  return;
               }
            }
         }
         if(this.newRmc.newRP.text != "")
         {
            this.EncryptStringRijndael();
         }
         var nrTimer:Timer = new Timer(800,1);
         nrTimer.addEventListener(TimerEvent.TIMER,goNewRoom);
         var roomObj:* = new Object();
         roomObj.roomUsers = 0;
         roomObj.roomLimit = this.newRmc.roomLimite.selectedItem.data;
         roomObj.roomName = this.newRmc.newRN.text;
         roomObj.roomTopic = this.newRmc.newRD.text;
         roomObj.password = this.myRoomPW;
         roomObj.roomVip = this.newRmc.newRV.selected;
         roomObj.sortRoom = 999999999 + this.generateRandomString(4);
         roomObj.roomID = "room_" + this.generateRandomString(20);
         roomObj.isPrivate = true;
         roomObj.autoRoom = false;
         roomObj.owner = this.myName;
         this.rooms_so.setProperty(roomObj.roomID,roomObj);
         this.roomID = roomObj.roomID;
         this.sendRoomKey = roomObj.password;
         this.changingRoom = true;
         this.tracker.trackPageview("USER_CREATED_ROOM:_" + this.roomID);
         nrTimer.start();
         var msgDest:* = this.myName + " se ha ido a " + roomObj.roomName;
         this.myRoomPW = "";
         this.closeWinNR();
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
         if(this.enterRoomMC.claveSala.text == "")
         {
            this.enterRoomMC.badpwd.visible = false;
            this.enterRoomMC.claveSala.setFocus();
            return;
         }
         this.decryptStringRijndael();
      }
      
      public function enterPWroomClose(param1:MouseEvent) : void
      {
         this.enterRoomMC.visible = false;
         this.enterRoomMC.badpwd.visible = false;
         this.Application.filters = null;
         this.Application.msg.setFocus();
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
         var _loc2_:String = null;
         this.myName = "     ";
         this.myGender = "     ";
         this.myCountry = "    ";
         this.myAge = 18;
         this.keyRoomStr = this.tempPW;
         this.tracker.trackPageview("CORRECT_ROOM_PASSWORD!");
         this.enterRoomMC.visible = false;
         this.enterRoomMC.badpwd.visible = false;
         this.changingRoom = true;
         this.Application.people_lb.removeAll();
         this.Application.people_lb.addItem({"label":"Cargando..."});
         this.closecam1();
         this.closecam2();
         this.closecam3();
         this.closePVwin();
         this.Application.History.htmlText = "";
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
      
      public function runInvite2(param1:MouseEvent) : void
      {
         this.inviteToWho = this.Application.cam2.cam1_wtxt.text;
         this.sendInvite();
      }
      
      public function runInvite3(param1:MouseEvent) : void
      {
         this.inviteToWho = this.Application.cam3.cam1_wtxt.text;
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
            this.invitePV(_loc1_);
            this.sendInvitation = false;
            this.invTimer.start();
         }
      }
      
      public function invitePV(param1:String) : void
      {
         this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' color=\'#0000FF\' size=\'12\'>* <font color=\'#FF0000\'>" + param1 + "</font> ha sido invitad@ a una sala privada...</font>");
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.nc.call("invitePV",null,param1,this.myName,this.myIPencrypted);
         this.tracker.trackPageview("Invitation_Sent");
      }
      
      public var invTimer:Timer;
      
      public function pvTimer(param1:TimerEvent) : void
      {
         this.sendInvitation = true;
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
            }
         };
         var flushStatus:String = null;
         try
         {
            flushStatus = this.local_so.flush(1000);
         }
         catch(error:Error)
         {
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
      
      public function closeCamClick(param1:MouseEvent) : void
      {
         this.closecam2();
      }
      
      public function closeCamClick3(param1:MouseEvent) : void
      {
         this.closecam3();
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
      
      public function likeUser(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam1.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc2_ + "!</b></font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.nc.call("likeYou",null,_loc2_,this.myName);
      }
      
      public function likeUser2(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam2.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc2_ + "!</b></font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.nc.call("likeYou",null,_loc2_,this.myName);
      }
      
      public function likeUser3(param1:MouseEvent) : void
      {
         var _loc2_:* = this.Application.cam3.cam1_wtxt.text;
         var _loc3_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc2_ + "!</b></font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         this.nc.call("likeYou",null,_loc2_,this.myName);
      }
      
      public function likeMe(param1:String) : void
      {
         this.nc.call("setVoteUp",null,this.myIP);
      }
      
      private var nc:NetConnection;
      
      private var lc:LocalConnection;
      
      private var fms_gateway:String;
      
      private var fms_country:String;
      
      private var Eql9844kmgldiroURrX998q12Vgm:String;
      
      var tracker:AnalyticsTracker;
      
      var isVip:Boolean = true;
      
      var adminStr:String = "";
      
      var vipStr:String = "8I3KQldk78247VzZdf092@!uIA3923fr";
      
      var stealthmode:Boolean = false;
      
      var myAlert:AlertWindow;
      
      var myAlert2:AlertWindow;
      
      var myAlert3:AlertWindow;
      
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
      
      var lobbyID:String;
      
      var keyRoomStr:String;
      
      var bellSound:Boolean = true;
      
      var bannedDevices:Array;
      
      var badCamsLoader:URLLoader;
      
      var chat_so:SharedObject;
      
      var users_so:SharedObject;
      
      var rooms_so:SharedObject;
      
      var timeOut:Boolean = false;
      
      var listStatus:String = "streaming";
      
      var maxUsers:Number;
      
      var freeTime:Number;
      
      var freeTime2:Number;
      
      var limitedCamTime:Number;
      
      var localCookie:String = "DefaultCookie";
      
      var UserInfo:Object;
      
      var roomID:String;
      
      var roomID2:String;
      
      var roomID3:String;
      
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
      
      var firstLobby:Boolean = true;
      
      var doOnceTimers:Boolean = true;
      
      public function LCTest() : void
      {
         this.lc = new LocalConnection();
         this.lc.client = this;
         this.lc.allowDomain("*");
         try
         {
            this.lc.connect("_myLCLock");
         }
         catch(e:ArgumentError)
         {
            login_mc.visible = false;
            showAlerts("<br><br>ChatVideo esta abierto en otra ventana<br><br>");
         }
      }
      
      private function connectApp() : void
      {
         if(this.firstLogon)
         {
            this.setFontTypeSO();
            this.login_mc.conn_anim.visible = true;
         }
         this.nc.connect(this.fms_gateway + this.roomID,this.myName,this.myGender,this.adminStr,this.stealthmode,this.myAge,this.myCountry,false,this.myIP,"",this.keyRoomStr);
      }
      
      private function connectCountry() : void
      {
         this.nc.connect(this.fms_country);
         this.tracker.trackPageview("Connecting_Country_RTMP");
      }
      
      function sendKA(param1:TimerEvent) : void
      {
         this.nc.call("keepAlive",null);
         this.tracker.trackPageview("Sending KeepAlive Call");
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
                  if(this.isVip == true)
                  {
                     stage.scaleMode = StageScaleMode.SHOW_ALL;
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
                  this.startCam();
               }
               return;
            case "NetConnection.Connect.Failed":
               this.showAlerts("<br><br>Conexion fallida con el servidor <br>Intenta nuevamente!<br><br>");
               this.login_mc.conn_anim.visible = false;
               this.login_mc.server_msg.text = "";
               this.login_mc.login_btn.enabled = true;
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
                  this.roomID = this.roomID2;
                  this.login_mc.login_btn.enabled = true;
                  this.login_mc.conn_anim.visible = false;
                  this.login_mc.visible = true;
                  this.Application.visible = false;
                  this.login_mc.server_msg.text = param1.info.application.msg;
                  if(this.firstLobby == false)
                  {
                     this.roomID = this.roomID3;
                     this.firstLobby = true;
                  }
                  this.firstLobby = false;
                  return;
               }
               this.showAlerts("<br><br>CONEXION RECHAZADA POR EL SERVIDOR<br><br>" + param1.info.application.msg + "<br>");
               this.login_mc.login_btn.enabled = true;
               this.login_mc.conn_anim.visible = false;
               this.login_mc.visible = true;
               this.Application.visible = false;
               this.tracker.trackPageview("Conn Rejected, Reason: " + param1.info.application.msg);
               this.login_mc.server_msg.text = param1.info.application.msg;
               this.nc.close();
               return;
         }
      }
      
      public function showAlerts(param1:*) : void
      {
         this.myAlert3 = new AlertWindow();
         var _loc2_:Object = {
            "colorA":12177384,
            "colorB":15265782,
            "thickness":1,
            "strokeColor":16777215,
            "blurColor":0,
            "blurAlpha":1,
            "curve":4
         };
         var _loc3_:Object = {
            "size":15,
            "color":0,
            "font":"_sans"
         };
         var _loc4_:Object = {
            "size":12,
            "color":600953,
            "font":"_sans"
         };
         var _loc5_:Object = {
            "colorA":15066597,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":8947848
         };
         var _loc6_:Object = {
            "colorA":11852007,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":1284567
         };
         var _loc7_:Object = {"color":14211288};
         var _loc8_:Object = {
            "mainBg":_loc2_,
            "message":_loc3_,
            "button":_loc4_,
            "buttonUp":_loc5_,
            "buttonOver":_loc6_,
            "freez":_loc7_
         };
         this.myAlert3.style = _loc8_;
         this.myAlert3.id = "systemInfo";
         this.myAlert3.message = param1;
         this.myAlert3.confirmBtn = "OK";
         this.addChild(this.myAlert3);
         this.myAlert3.show();
         this.tracker.trackPageview("Alert: " + param1);
      }
      
      public function showAlerts2(param1:String, param2:String) : void
      {
         this.inviteSender = param1;
         this.inviteSenderIP = param2;
         if(this.alertOn)
         {
            this.removeChild(this.myAlert);
            this.alertOn = false;
         }
         this.myAlert = new AlertWindow();
         var _loc3_:Object = {
            "colorA":12177384,
            "colorB":15265782,
            "thickness":1,
            "strokeColor":16777215,
            "blurColor":0,
            "blurAlpha":1,
            "curve":4
         };
         var _loc4_:Object = {
            "size":15,
            "color":0,
            "font":"_sans"
         };
         var _loc5_:Object = {
            "size":12,
            "color":600953,
            "font":"_sans"
         };
         var _loc6_:Object = {
            "colorA":15066597,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":8947848
         };
         var _loc7_:Object = {
            "colorA":11852007,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":1284567
         };
         var _loc8_:Object = {"color":14211288};
         var _loc9_:Object = {
            "mainBg":_loc3_,
            "message":_loc4_,
            "button":_loc5_,
            "buttonUp":_loc6_,
            "buttonOver":_loc7_,
            "freez":_loc8_
         };
         this.myAlert.style = _loc9_;
         this.myAlert.id = "btn1";
         this.myAlert.message = param1 + "<br><br>Te ha invitado a una sala privada...";
         this.myAlert.confirmBtn = "ACEPTAR";
         this.myAlert.rejectBtn = "RECHAZAR";
         this.myAlert.addEventListener(AlertEvents.CONFIRM,this.inviteOnAccept);
         this.myAlert.addEventListener(AlertEvents.REJECT,this.inviteOnReject);
         this.addChild(this.myAlert);
         this.myAlert.show();
         this.tracker.trackPageview("Invitation Received!");
         this.alertOn = true;
      }
      
      public function showRegAlert(param1:String) : void
      {
         this.myAlert2 = new AlertWindow();
         var _loc2_:Object = {
            "colorA":12177384,
            "colorB":15265782,
            "thickness":1,
            "strokeColor":16777215,
            "blurColor":0,
            "blurAlpha":1,
            "curve":4
         };
         var _loc3_:Object = {
            "size":15,
            "color":0,
            "font":"_sans"
         };
         var _loc4_:Object = {
            "size":12,
            "color":600953,
            "font":"_sans"
         };
         var _loc5_:Object = {
            "colorA":15066597,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":8947848
         };
         var _loc6_:Object = {
            "colorA":11852007,
            "colorB":16777215,
            "thickness":0.5,
            "strokeColor":1284567
         };
         var _loc7_:Object = {"color":14211288};
         var _loc8_:Object = {
            "mainBg":_loc2_,
            "message":_loc3_,
            "button":_loc4_,
            "buttonUp":_loc5_,
            "buttonOver":_loc6_,
            "freez":_loc7_
         };
         this.myAlert2.style = _loc8_;
         this.myAlert2.id = "RegAlert";
         this.myAlert2.message = param1;
         this.myAlert2.confirmBtn = "Registrarme";
         this.myAlert2.rejectBtn = "Cerrar";
         this.myAlert2.addEventListener(AlertEvents.CONFIRM,this.regAlertResponse);
         this.addChild(this.myAlert2);
         this.myAlert2.show();
         this.tracker.trackPageview("Show Reg Alert:" + param1);
      }
      
      function regAlertResponse(param1:Event) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.chatvideo.es/reg.html");
         navigateToURL(_loc2_,"_blank");
         this.tracker.trackPageview("REGISTER_URL_CLICKED");
      }
      
      function inviteOnAccept(param1:Event) : void
      {
         this.tracker.trackPageview("PRIVATE_INVIT_ACCEPTED");
         this.inviteAccept(this.inviteSender);
      }
      
      function inviteOnReject(param1:Event) : void
      {
         this.nc.call("PVrejected",null,this.inviteSender,this.myName);
         this.tracker.trackPageview("PRIVATE_INVIT_REJECTED");
      }
      
      public function rejectedPV(param1:String) : void
      {
         this.tracker.trackPageview("PV INVIT REJECTED BY: " + param1);
         this.Application.History.htmlText = this.Application.History.htmlText + ("<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + param1 + " no aceptó tu invitación.");
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function acceptedPV(param1:String) : void
      {
         var goPV:Function = null;
         var pvRoomID:String = param1;
         goPV = function():void
         {
            Application.History.htmlText = "";
            closecam1();
            closecam2();
            closecam3();
            tracker.trackPageview("PV INVIT ACCEPTED, GOING PV");
            connectApp();
         };
         var pvTimer:Timer = new Timer(1000,1);
         pvTimer.addEventListener(TimerEvent.TIMER,goPV);
         this.roomID = pvRoomID;
         this.changingRoom = true;
         this.Application.people_lb.removeAll();
         this.Application.people_lb.addItem({"label":"Cargando..."});
         pvTimer.start();
         this.doDisconnect();
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
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function serverMsg(param1:String, param2:String) : void
      {
         this.tracker.trackPageview("From Server: " + param1);
         var _loc3_:* = "<font face=\'Arial\' size=\'12\' color=\"" + param2 + "\">" + param1 + "</font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc3_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         this.Application.History.htmlText = this.Application.History.htmlText + param1;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function ignoredMe2(param1:String) : void
      {
         var _loc2_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'>* " + param1 + " no acepta mensajes privados</font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc2_;
         this.tracker.trackPageview("NOT ACCEPTING PM: " + param1);
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function receiveAdminMessage(param1:String) : void
      {
         this.Application.History.htmlText = this.Application.History.htmlText + param1;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function vipME(param1:String) : void
      {
      }
      
      public function receiveHistory(param1:String) : void
      {
         this.Application.History.htmlText = "";
         this.tracker.trackPageview("Chat_Cleared");
      }
      
      public function receiveTimeOut(param1:String) : void
      {
         this.tracker.trackPageview("MASS TIMEOUT FROM ADMIN");
      }
      
      public function setCountry(param1:String) : void
      {
         this.myIP = param1;
         this.sendRealIP(this.myIP);
         this.tracker.trackPageview("setCountry();");
      }
      
      public function setRoomNameAndID(param1:String, param2:String) : void
      {
         this.tracker.trackPageview("Room Name: " + param1);
         this.currentRoomID = param2;
         this.roomTitle = param1;
         this.Application.chat_title.text = "Chat en " + param1;
         this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' color=\'#000000\' size=\'12\'>Bienvenido a la sala <font color=\'#FF0000\'>" + param1 + "</font>");
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function onRoomownerauth() : void
      {
         var kickUser:Function = null;
         kickUser = function(param1:MouseEvent):void
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
         this.nc.call("runTimer",null);
         this.killTimer.start();
         if(this.firstOwnerAuth)
         {
            this.Application.modTools.kick_bt.addEventListener(MouseEvent.CLICK,kickUser);
            this.Application.modTools.ban_bt.addEventListener(MouseEvent.CLICK,this.iBanUser);
            this.firstOwnerAuth = false;
         }
      }
      
      function iBanUser(param1:MouseEvent) : void
      {
         var _loc2_:* = this.theWho;
         if(_loc2_ != undefined)
         {
            this.nc.call("BanUser",null,_loc2_,this.myName);
         }
      }
      
      public function inviteME(param1:String, param2:String) : void
      {
         this.tracker.trackPageview("PV INVIT");
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
         var _loc4_:* = param1 + " te ha invitado a una sala privada";
         if(this.Application.optionsMC.invCheck.selected != true)
         {
            return;
         }
         this.showAlerts2(param1,param2);
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         while(_loc4_ < this.ignoredPPL.length)
         {
            if(this.ignoredPPL[_loc4_] == _loc3_[1])
            {
               this.ignoTip(_loc3_[0] + " ya esta siendo ignorad@");
               this.tracker.trackPageview("ALREADY_IGNORING_THAT_PERSON");
               return;
            }
            _loc4_++;
         }
         this.Application.History.htmlText = this.Application.History.htmlText + ("<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc3_[0] + " ha sido ignorad@");
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
         var _loc5_:* = _loc3_[0];
         var _loc6_:* = this.myName;
         this.ignoredPPL.push(_loc3_[1]);
         this.nc.call("IgnoUser",null,_loc5_,_loc6_);
      }
      
      public function ignoredMe(param1:String) : void
      {
      }
      
      public function Banned(param1:String) : void
      {
         this.showAlerts("<br><br>Has sido Bloqueado por " + param1 + "<br><br>");
      }
      
      public function kickMe(param1:String) : void
      {
         this.showAlerts("<br><br>Has sido Expulsad@ por " + param1 + "<br><br>");
      }
      
      public function Banned2(param1:String) : void
      {
      }
      
      public function floodBan(param1:String) : void
      {
      }
      
      public function flagMe(param1:String) : void
      {
         this.showAlerts("<br><br>Has sido flagueado por " + param1 + "<br><br>");
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
         this.showAlerts("<br><br>La sala ha finalizado sesión<br>Has ingresado a Lobby<br><br>");
         this.roomID = this.lobbyID;
         if((this.isVip) && (this.sending_video))
         {
            this.stopCam();
         }
         this.changingRoom = true;
         this.Application.History.htmlText = "";
         this.nc.close();
         this.doDisconnect();
         this.connectApp();
      }
      
      public function close() : void
      {
      }
      
      public function globalMsg(param1:String) : void
      {
         var _loc2_:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'><br><br><br><b>" + param1 + "</b><br><br><br></font>";
         this.Application.History.htmlText = this.Application.History.htmlText + _loc2_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
      }
      
      public function onReceiveMsgMobile(param1:String, param2:String, param3:String, param4:String, param5:String) : void
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
         if(this.Application.History.length > 21400)
         {
            this.Application.History.htmlText = "";
         }
         if(param2 == this.myName)
         {
            _loc6_ = "<b><font face=\'Tahoma\' size=\'15\' color=\'#FF7004\'> " + param2 + ": </font></b>" + param1;
            this.Application.History.htmlText = this.Application.History.htmlText + _loc6_;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
         }
         _loc6_ = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><b><font face=\'Tahoma\' size=\'14\' color=\'#FF7004\'> " + param2 + ": </font></b>" + param1;
         this.Application.History.htmlText = this.Application.History.htmlText + _loc6_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
         if(this.Application.History.length > 21400)
         {
            this.Application.History.htmlText = "";
         }
         if(param2 == this.myName)
         {
            _loc6_ = "<b><font face=\'Tahoma\' size=\'15\' color=\'#000000\'> " + param2 + ": </font></b>" + param1;
            this.Application.History.htmlText = this.Application.History.htmlText + _loc6_;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
         }
         _loc6_ = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><font face=\'Tahoma\' size=\'14\' color=\'#002A45\'><b> " + param2 + ": </b></font><font size=\'13\'>" + param1;
         this.Application.History.htmlText = this.Application.History.htmlText + _loc6_;
         this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
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
      
      function frame1() : *
      {
         stop();
         this.addEventListener(Event.ENTER_FRAME,this.loading);
         stage.scaleMode = StageScaleMode.NO_SCALE;
      }
      
      function frame2() : *
      {
         stop();
         this.myBell = new Sound();
         this.xmlLoader = new URLLoader();
         this.xmlLoader = new URLLoader();
         this.xmlLoader.addEventListener(Event.COMPLETE,this.loadXML);
         this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.loaderMissing);
         this.xmlData = new XML();
         this.xmlFile = "v18.xml" + "?" + Math.random();
         this.xmlLoader.load(new URLRequest(this.xmlFile));
         this.url = "http://www.chatvideo.es/local_as3.php";
         this.bf = new BlurFilter(5,5,5);
         this.enterRoomMC.visible = false;
         this.enterRoomMC.badpwd.visible = false;
         this.login_mc.conn_anim.visible = false;
         this.Application.bigRegister.visible = false;
         this.Application.visible = false;
         this.newRmc.visible = false;
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
         this.Application.cam1.likeCam.setStyle("icon",like_graphic);
         this.Application.cam2.likeCam.setStyle("icon",like_graphic);
         this.Application.cam3.likeCam.setStyle("icon",like_graphic);
         this.Application.cam1.likeCam.setStyle("textPadding",0);
         this.Application.cam2.likeCam.setStyle("textPadding",0);
         this.Application.cam3.likeCam.setStyle("textPadding",0);
         this.Application.option_bt.setStyle("icon",settings_graphic);
         this.Application.cam1.flag_bt.setStyle("icon",warning_graphic);
         this.Application.cam1.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.cam2.flag_bt.setStyle("icon",warning_graphic);
         this.Application.cam2.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.cam3.flag_bt.setStyle("icon",warning_graphic);
         this.Application.cam3.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.mensPv.invite_bt.setStyle("icon",corazon_graphic);
         this.Application.optionsMC.cam_conf_bt.setStyle("icon",webcam_graphic);
         this.Application.optionsMC.close_opt.setStyle("icon",check_graphic);
         this.Application.create_pb.setStyle("icon",add_graphic);
         this.Application.logout_bt.setStyle("icon",logout_graphic);
         this.likesCam1Format = new TextFormat();
         this.likesCam1Format.font = "Tahoma";
         this.likesCam1Format.color = 0;
         this.likesCam1Format.size = "12";
         this.likesCam1Format.bold = true;
         this.Application.cam1.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.Application.cam2.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.Application.cam3.likeCam.setStyle("textFormat",this.likesCam1Format);
         this.formatMsg = new TextFormat();
         this.formatMsg.font = "Verdana";
         this.formatMsg.color = 0;
         this.formatMsg.size = "13";
         this.formatMsg.bold = false;
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
         this.formatPVMsg = new TextFormat();
         this.formatPVMsg.font = "Tahoma";
         this.formatPVMsg.color = 16711680;
         this.formatPVMsg.size = "16";
         this.formatPVMsg.bold = true;
         this.loginFormat = new TextFormat();
         this.loginFormat.font = "Tahoma";
         this.loginFormat.color = 1205949;
         this.loginFormat.size = "16";
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
         this.Application.activateCam.setStyle("textFormat",this.startCamFormat);
         this.Application.activateMic.setStyle("textFormat",this.startCamFormat);
         this.optionsFormat = new TextFormat();
         this.optionsFormat.font = "Tahoma";
         this.optionsFormat.color = 3355443;
         this.optionsFormat.size = "12";
         this.optionsFormat.bold = true;
         this.Application.optionsMC.vipCheck.setStyle("textFormat",this.optionsFormat);
         this.Application.optionsMC.userCheck.setStyle("textFormat",this.optionsFormat);
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
         this.Application.adminTools.visible = false;
         this.Application.fontSel.visible = false;
         this.Application.cam1.close_bt.addEventListener(MouseEvent.CLICK,this.cierraCam);
         this.Application.sort_bt.addEventListener(MouseEvent.CLICK,this.sortPeople);
         this.Application.bigRegister.bigLink.addEventListener(MouseEvent.CLICK,this.regCLickURL);
         this.Application.bigRegister.closeLink.addEventListener(MouseEvent.CLICK,this.closeCLick);
         this.Application.fullScreen_bt.addEventListener(MouseEvent.CLICK,this._handleClick);
         this.fontSelFormat = new TextFormat();
         this.fontSelFormat.font = "Tahoma";
         this.fontSelFormat.color = 4299399;
         this.fontSelFormat.size = "14";
         this.fontSelFormat.bold = true;
         this.Application.fontSel.setRendererStyle("textFormat",this.fontSelFormat);
         this.Application.fontSel.rowHeight = 25;
         this.Application.fontSel.addItem({"label":"Arial"});
         this.Application.fontSel.addItem({"label":"Comic Sans MS"});
         this.Application.fontSel.addItem({"label":"Courier New"});
         this.Application.fontSel.addItem({"label":"Calibri"});
         this.Application.fontSel.addItem({"label":"Consolas"});
         this.Application.fontSel.addItem({"label":"Courier New"});
         this.Application.fontSel.addItem({"label":"Franklin Gothic Medium"});
         this.Application.fontSel.addItem({"label":"Georgia"});
         this.Application.fontSel.addItem({"label":"Kartika"});
         this.Application.fontSel.addItem({"label":"MS Serif"});
         this.Application.fontSel.addItem({"label":"MV Boli"});
         this.Application.fontSel.addItem({"label":"Palatino Linotype, Book Antiqua"});
         this.Application.fontSel.addItem({"label":"Segoe Print"});
         this.Application.fontSel.addItem({"label":"Segoe Script"});
         this.Application.fontSel.addItem({"label":"Segoe UI"});
         this.Application.fontSel.addItem({"label":"Tahoma"});
         this.Application.fontSel.addItem({"label":"Trebuchet MS"});
         this.Application.fontSel.addItem({"label":"Verdana"});
         this.Application.fontSel.addItem({"label":"Westminster"});
         this.Application.option_bt.addEventListener(MouseEvent.CLICK,this.showOptionsPanel);
         this.Application.optionsMC.close_opt.addEventListener(MouseEvent.CLICK,this.closeOptionsPanel);
         this.login_mc.server_msg.visible = false;
         this.killTimer = new Timer(7000,0);
         this.killTimer.addEventListener(TimerEvent.TIMER,this.sendKA);
         this.login_mc.login_btn.addEventListener(MouseEvent.CLICK,this.loginUser);
         this.genderGroup = new RadioButtonGroup("genderRadio");
         this.login_mc.maleRadio.addEventListener(MouseEvent.CLICK,this.announceCurrentGroup);
         this.login_mc.femaleRadio.addEventListener(MouseEvent.CLICK,this.announceCurrentGroup);
         this.login_mc.coupleRadio.addEventListener(MouseEvent.CLICK,this.announceCurrentGroup);
         this.reportedPPL = new Array();
         this.rijndael_key5 = "79566214843925";
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.CLICK,this.reportUser);
         this.Application.cam2.flag_bt.addEventListener(MouseEvent.CLICK,this.reportUser2);
         this.Application.cam3.flag_bt.addEventListener(MouseEvent.CLICK,this.reportUser3);
         this.Application.cam1.visible = false;
         this.Application.cam2.visible = false;
         this.Application.cam3.visible = false;
         this.Application.cam1.volMC.muteIcon.visible = false;
         this.Application.cam2.volMC.muteIcon.visible = false;
         this.Application.cam3.volMC.muteIcon.visible = false;
         this.soundXForm = new SoundTransform();
         this.soundXForm2 = new SoundTransform();
         this.soundXForm3 = new SoundTransform();
         this.mobileStream = false;
         this.ctrlON = false;
         this.Application.cam1.addEventListener(MouseEvent.MOUSE_OVER,this.HandleMouseOver);
         this.Application.cam1.addEventListener(MouseEvent.MOUSE_OUT,this.HandleMouseOut);
         this.Application.cam1.underbutt.visible = false;
         this.Application.cam2.underbutt.visible = false;
         this.Application.cam3.underbutt.visible = false;
         this.Application.cam2.addEventListener(MouseEvent.MOUSE_OVER,this.HandleMouseOver2);
         this.Application.cam2.addEventListener(MouseEvent.MOUSE_OUT,this.HandleMouseOut2);
         this.Application.cam3.addEventListener(MouseEvent.MOUSE_OVER,this.HandleMouseOver3);
         this.Application.cam3.addEventListener(MouseEvent.MOUSE_OUT,this.HandleMouseOut3);
         this.Application.cam1.volMC.volSlide.addEventListener(SliderEvent.CHANGE,this.volChange);
         this.Application.cam2.volMC.volSlide.addEventListener(SliderEvent.CHANGE,this.volChange2);
         this.Application.cam3.volMC.volSlide.addEventListener(SliderEvent.CHANGE,this.volChange3);
         this.LCTest();
         this.curSelectionUser = null;
         this.globalMessage = "";
         this.doSyncOnce = true;
         this.Application.History.addEventListener(TextEvent.LINK,this.ignoreLink);
         this.updateTimer = new Timer(4000,1);
         this.updateTimer.addEventListener(TimerEvent.TIMER,this.onTimeUp);
         this.updateTimer67 = new Timer(3000,0);
         this.updateTimer67.addEventListener(TimerEvent.TIMER,this.onTimeUp888);
         this.Application.mensPv.visible = false;
         this.usersDP = new DataProvider();
         this.Application.people_lb.dataProvider = this.usersDP;
         this.Application.people_lb.iconFunction = this.determineIcon;
         this.Application.people_lb.addEventListener(Event.CHANGE,this.selectedUser);
         this.roomsDP = new DataProvider();
         this.Application.rooms_lb.dataProvider = this.roomsDP;
         this.Application.mensPv.sendPV_but.addEventListener(MouseEvent.CLICK,this.doSendPV);
         this.Application.msg.addEventListener(FocusEvent.FOCUS_IN,this.onTextSelect);
         this.Application.mensPv.pv_msg.addEventListener(FocusEvent.FOCUS_IN,this.onTextSelect);
         this.Application.send_pb.addEventListener(MouseEvent.CLICK,this.doSend);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         this.Application.mensPv.closePV_but.addEventListener(MouseEvent.CLICK,this.closePV);
         this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OVER,this.showCreateTip);
         this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OUT,this.hideCreateTip);
         this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showInviteTip);
         this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideInviteTip);
         this.Application.cam2.invite_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showInviteTip2);
         this.Application.cam2.invite_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideInviteTip);
         this.Application.cam3.invite_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showInviteTip3);
         this.Application.cam3.invite_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideInviteTip);
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showFlagTip);
         this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideFlagTip);
         this.Application.cam2.flag_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showFlagTip);
         this.Application.cam2.flag_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideFlagTip);
         this.Application.cam3.flag_bt.addEventListener(MouseEvent.MOUSE_OVER,this.showFlagTip);
         this.Application.cam3.flag_bt.addEventListener(MouseEvent.MOUSE_OUT,this.hideFlagTip);
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
         this.Application.myCamMC.micVol.addEventListener(SliderEvent.CHANGE,this.setMicLevel);
         this.Application.activateCam.addEventListener(MouseEvent.CLICK,this.cameraHandler);
         this.Application.optionsMC.bellCheck.addEventListener(MouseEvent.CLICK,this.bellHandler);
         this.Application.optionsMC.vipCheck.addEventListener(MouseEvent.CLICK,this.vipCamHandler);
         this.Application.activateMic.addEventListener(MouseEvent.CLICK,this.micHandler);
         this.badCamsLoader.addEventListener(Event.COMPLETE,this.onBadCamsLoaded);
         this.badCamsLoader.addEventListener(IOErrorEvent.IO_ERROR,this.badCamsError);
         this.badCamsLoader.load(new URLRequest("badCams.txt" + "?" + Math.random()));
         this.fakeTimer = new Timer(4000,0);
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
         this.Application.cam2.invite_bt.addEventListener(MouseEvent.CLICK,this.runInvite2);
         this.Application.cam3.invite_bt.addEventListener(MouseEvent.CLICK,this.runInvite3);
         this.Application.mensPv.invite_bt.addEventListener(MouseEvent.CLICK,this.runInvite4);
         this.invTimer = new Timer(10000,1);
         this.invTimer.addEventListener(TimerEvent.TIMER,this.pvTimer);
         this.imgLoad = false;
         this.imgLoad2 = false;
         this.imgLoad3 = false;
         this.local_so = SharedObject.getLocal("VIP_V3");
         if(this.local_so.data.myName != undefined)
         {
            this.formatMsg.font = this.local_so.data.myFontType;
            this.formatMsg.color = this.local_so.data.myColor;
            this.formatMsg.bold = this.local_so.data.myFontBold;
            this.formatMsg.italic = this.local_so.data.myFontItalic;
            this.Application.msg.setStyle("textFormat",this.formatMsg);
            this.loginFormat.color = this.local_so.data.myColor;
            this.login_mc.login_name.setStyle("textFormat",this.loginFormat);
            this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
         }
         if(this.local_so.data.myVotes == undefined)
         {
            this.local_so.data.myVotes = 0;
            this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
         }
         this.Application.cam2.close_bt.addEventListener(MouseEvent.CLICK,this.closeCamClick);
         this.Application.cam3.close_bt.addEventListener(MouseEvent.CLICK,this.closeCamClick3);
         this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler4);
         this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler4);
         this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser);
         this.Application.cam2.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser2);
         this.Application.cam3.likeCam.addEventListener(MouseEvent.CLICK,this.likeUser3);
      }
   }
}
