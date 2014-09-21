package 
{
    import com.google.analytics.*;
    import com.meychi.ascrypt3.*;
    import com.myflashlab.classes.tools.infoBox.alert.*;
    import fl.controls.*;
    import fl.data.*;
    import fl.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class videoChat extends MovieClip
    {
        public var Application:MovieClip;
        public var bar_mc:MovieClip;
        public var enterRoomMC:MovieClip;
        public var login_mc:MovieClip;
        public var newRmc:MovieClip;
        public var vipUser:String;
        public var sound1:String;
        public var myBell:Sound;
        public var xmlLoader:URLLoader;
        public var xmlData:XML;
        public var xmlFile:Object;
        public var request:URLRequest;
        public var VIPloader:URLLoader;
        public var url:String;
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
        public var textFilter:GlowFilter;
        public var fontSelFormat:TextFormat;
        public var killTimer:Timer;
        public var genderGroup:RadioButtonGroup;
        public var reportedPPL:Object;
        public var rijndael_key5:String;
        public var userIPdecrypted:String;
        public var soundXForm:SoundTransform;
        public var soundXForm2:SoundTransform;
        public var soundXForm3:SoundTransform;
        public var publish_ns:NetStream;
        public var play_ns:NetStream;
        public var play_ns2:NetStream;
        public var play_ns3:NetStream;
        public var mobileStream:Boolean;
        public var ctrlON:Boolean;
        public var curSelectionUser:String;
        public var tempPW:String;
        public var theWho:String;
        public var goingToRoom:String;
        public var globalMessage:String;
        public var doSyncOnce:Boolean;
        public var myIPencrypted:String;
        public var updateTimer:Timer;
        public var updateTimer67:Timer;
        public var usersDP:DataProvider;
        public var roomsDP:DataProvider;
        public var myTimer:Timer;
        public var h264Config:H264VideoStreamSettings;
        public var cam:Camera;
        public var mic:Microphone;
        public var deviceName:String;
        public var mic_on:Boolean;
        public var camTimeUp:Boolean;
        public var minutesToGo2:String;
        public var sendCamTimeN:Number;
        public var fakeTimer:Timer;
        public var rijndael_key:String;
        public var myRoomPW:String;
        public var sendRoomKey:String;
        public var sendInvitation:Boolean;
        public var inviteToWho:String;
        public var invTimer:Timer;
        public var imageLoader:Loader;
        public var flagPath:String;
        public var imgLoad:Boolean;
        public var imageLoader2:Loader;
        public var imgLoad2:Boolean;
        public var imageLoader3:Loader;
        public var imgLoad3:Boolean;
        public var local_so:SharedObject;
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
        var ignoredPPL:Object;
        var inviteSender:String;
        var inviteSenderIP:String;
        var flagMeArray:Object;
        var likeMeArray:Object;
        var flagMeLimit:Number;
        var firstLobby:Boolean = true;
        var doOnceTimers:Boolean = true;

        public function videoChat() : void
        {
            this.tracker = new GATracker(stage, "UA-6669334-1", "AS3", false);
            this.bannedDevices = new Array();
            this.badCamsLoader = new URLLoader();
            this.UserInfo = {};
            this.ignoredPPL = new Array();
            this.flagMeArray = new Array();
            this.likeMeArray = new Array();
            addFrameScript(0, this.frame1, 1, this.frame2);
            this.nc = new NetConnection();
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this.nc.client = this;
            return;
        }// end function

        public function loading(event:Event) : void
        {
            var _loc_2:* = this.stage.loaderInfo.bytesTotal;
            var _loc_3:* = this.stage.loaderInfo.bytesLoaded;
            this.bar_mc.scaleX = _loc_3 / _loc_2;
            if (_loc_2 == _loc_3)
            {
                nextFrame();
                this.removeEventListener(Event.ENTER_FRAME, this.loading);
            }
            return;
        }// end function

        public function loaderMissing(event:IOErrorEvent) : void
        {
            this.tracker.trackPageview("XML ERROR, IS  YOUR XML FILE THERE?");
            this.showAlerts("<br><br>Error XML, Te recomendamos borrar el cache<br>de tu navegador y recargar la pagina.<br>");
            this.login_mc.login_btn.enabled = false;
            this.login_mc.visible = false;
            return;
        }// end function

        public function loadXML(event:Event) : void
        {
            this.xmlData = new XML(event.target.data);
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
            return;
        }// end function

        public function loaderMissing2(event:IOErrorEvent) : void
        {
            this.tracker.trackPageview("Error Loading VIP Username");
            this.showAlerts("<br><br>Error al obtener nombre de usuario<br>Por favor reinicia la página.<br><br> ");
            this.login_mc.login_btn.enabled = false;
            this.login_mc.visible = false;
            return;
        }// end function

        public function completeHandler(event:Event)
        {
            this.vipUser = event.target.data.username;
            this.login_mc.login_name.text = this.vipUser;
            return;
        }// end function

        public function sendRealIP(param1:String) : void
        {
            var recibir:URLLoader;
            var Respuesta:Function;
            var HayError:Function;
            var realIP:* = param1;
            Respuesta = function (event:Event)
            {
                changingRoom = true;
                myCountry = recibir.data.replace(/^\s+|\s+$/g, "");
                if (myCountry.length > 25)
                {
                    myCountry = "Unknown";
                }
                nc.close();
                countryConn = false;
                connectApp();
                tracker.trackPageview("Set Real Country: " + myCountry);
                return;
            }// end function
            ;
            HayError = function (event:IOErrorEvent) : void
            {
                return;
            }// end function
            ;
            var enviar:* = new URLRequest(this.url);
            recibir = new URLLoader();
            var variables:* = new URLVariables();
            variables.ip = realIP;
            enviar.method = URLRequestMethod.POST;
            enviar.data = variables;
            recibir.dataFormat = URLLoaderDataFormat.TEXT;
            recibir.addEventListener(Event.COMPLETE, Respuesta);
            recibir.addEventListener(IOErrorEvent.IO_ERROR, HayError);
            recibir.load(enviar);
            return;
        }// end function

        public function doBold(event:MouseEvent) : void
        {
            this.tracker.trackPageview("boldFontClicked");
            if (this.formatMsg.bold == false)
            {
                this.formatMsg.bold = true;
                this.local_so.data.myFontBold = true;
            }
            else
            {
                this.formatMsg.bold = false;
                this.local_so.data.myFontBold = false;
            }
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            return;
        }// end function

        public function doUnderline(event:MouseEvent) : void
        {
            if (this.formatMsg.underline == false)
            {
                this.formatMsg.underline = true;
            }
            else
            {
                this.formatMsg.underline = false;
            }
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            return;
        }// end function

        public function doItalic(event:MouseEvent) : void
        {
            this.tracker.trackPageview("ItalicFontClicked");
            if (this.formatMsg.italic == false)
            {
                this.formatMsg.italic = true;
                this.local_so.data.myFontItalic = true;
            }
            else
            {
                this.formatMsg.italic = false;
                this.local_so.data.myFontItalic = false;
            }
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            return;
        }// end function

        public function changeHandler(event:ColorPickerEvent) : void
        {
            this.formatMsg.color = "0x" + event.target.hexValue;
            this.myColor = "#" + event.target.hexValue;
            this.myColorX = "0x" + event.target.hexValue;
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            this.tracker.trackPageview("FONT COLOR: " + this.myColor);
            this.local_so.data.myColor = this.myColorX;
            return;
        }// end function

        public function changeFontSize(event:MouseEvent) : void
        {
            if (this.formatMsg.size == "13")
            {
                this.formatMsg.size = "14";
                this.local_so.data.myFontSize = "14";
            }
            else
            {
                this.formatMsg.size = "13";
                this.local_so.data.myFontSize = "13";
            }
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            return;
        }// end function

        public function changeFont(event:Event) : void
        {
            this.formatMsg.font = this.Application.fontSel.selectedItem.label;
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            this.Application.fontSel.visible = false;
            this.tracker.trackPageview("SELECTED_FONT:_" + this.Application.fontSel.selectedItem.label);
            this.local_so.data.myFontType = this.Application.fontSel.selectedItem.label;
            return;
        }// end function

        public function showFonts(event:MouseEvent) : void
        {
            this.Application.fontSel.visible = true;
            return;
        }// end function

        public function cierraCam(event:MouseEvent) : void
        {
            this.closecam1();
            return;
        }// end function

        public function sortPeople(event:MouseEvent) : void
        {
            this.tracker.trackPageview("SORT_BUTTON_CLICKED");
            if (this.listStatus == "label")
            {
                this.listStatus = "streaming";
            }
            else if (this.listStatus == "streaming")
            {
                this.listStatus = "label";
            }
            return;
        }// end function

        public function goFullScreen() : void
        {
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            else
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
            return;
        }// end function

        public function regCLickURL(event:MouseEvent) : void
        {
            this.tracker.trackPageview("RegLink Register Button Clicked");
            var _loc_2:* = new URLRequest("http://www.chatvideo.es/reg.html");
            navigateToURL(_loc_2, "_parent");
            return;
        }// end function

        public function closeCLick(event:MouseEvent) : void
        {
            this.tracker.trackPageview("Close RegLink Clicked");
            this.Application.bigRegister.visible = false;
            return;
        }// end function

        public function _handleClick(event:MouseEvent) : void
        {
            var _loc_2:* = undefined;
            this.tracker.trackPageview("fullScreen Clicked");
            if (this.isVip == false)
            {
                _loc_2 = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>Debes ser usuario <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Registrado</a></u></font> para ver pantalla completa.</font>";
                this.Application.History.htmlText = this.Application.History.htmlText + _loc_2;
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            this.goFullScreen();
            return;
        }// end function

        public function showOptionsPanel(event:MouseEvent) : void
        {
            this.tracker.trackPageview("Opciones_Clicked");
            this.Application.optionsMC.visible = true;
            return;
        }// end function

        public function closeOptionsPanel(event:MouseEvent) : void
        {
            this.Application.optionsMC.visible = false;
            return;
        }// end function

        public function setFontTypeSO() : void
        {
            this.local_so.data.myFontType = this.formatMsg.font;
            this.local_so.data.myColor = this.formatMsg.color;
            this.local_so.data.myFontBold = this.formatMsg.bold;
            this.local_so.data.myFontItalic = this.formatMsg.italic;
            return;
        }// end function

        public function announceCurrentGroup(event:MouseEvent) : void
        {
            this.myGender = event.target.value;
            return;
        }// end function

        public function loginUser(event:MouseEvent) : void
        {
            this.login_mc.server_msg.visible = false;
            this.login_mc.server_msg.text = "";
            if (this.login_mc.login_name.text == "" || this.login_mc.login_name.text == "undefined")
            {
                this.login_mc.server_msg.visible = true;
                this.login_mc.server_msg.text = "Error de Usuario, Recarga la página.";
                return;
            }
            if (this.login_mc.login_name.text.length < 4)
            {
                this.login_mc.server_msg.visible = true;
                this.login_mc.server_msg.text = "Nombre muy corto, intenta nuevamente.";
                this.tracker.trackPageview("Name Too Short");
                return;
            }
            if (this.myGender == "")
            {
                this.login_mc.server_msg.visible = true;
                this.login_mc.server_msg.text = "Chico, Chica o Pareja?";
                return;
            }
            if (this.login_mc.age_box.selectedItem.data == "no")
            {
                this.login_mc.server_msg.visible = true;
                this.login_mc.server_msg.text = "Tu Edad ?";
                this.tracker.trackPageview("Age Missing @ Login");
                return;
            }
            if (this.login_mc.certi_ch.selected == false)
            {
                this.login_mc.server_msg.visible = true;
                this.showAlerts("Debes aceptar los términos de uso.");
                this.login_mc.server_msg.text = "Debes aceptar los terminos de uso.";
                this.tracker.trackPageview("Forgot_to_Check_AGREE_the_TERMS");
                return;
            }
            this.login_mc.server_msg.text = "Conectando ...";
            this.login_mc.server_msg.visible = true;
            this.login_mc.login_btn.enabled = false;
            this.login_mc.conn_anim.visible = true;
            this.myAge = this.login_mc.age_box.selectedItem.label;
            this.myName = this.vipUser;
            this.Application.myCamMC.myName.text = this.myName;
            this.Application.myRedNick.text = this.myName;
            this.Application.myCamMC.maleIconTop.visible = false;
            this.Application.myCamMC.femaleIconTop.visible = false;
            this.Application.myCamMC.coupleIconTop.visible = false;
            if (this.myGender == "male")
            {
                this.Application.myCamMC.maleIconTop.visible = true;
            }
            if (this.myGender == "female")
            {
                this.Application.myCamMC.femaleIconTop.visible = true;
            }
            if (this.myGender == "couple" && this.isVip == true)
            {
                this.Application.myCamMC.coupleIconTop.visible = true;
            }
            this.login_mc.server_msg.visible = false;
            this.connectCountry();
            this.storeLocalSO();
            this.Eql9844kmgldiroURrX998q12Vgm = this.myName;
            return;
        }// end function

        public function reportUser(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam1.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc_2 + " ha sido reportad@ como inapropiad@</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.myTooltip2.hide();
            this.reportedPPL.push(_loc_2);
            this.tracker.trackPageview("User Flagged");
            this.nc.call("flagThis", null, _loc_2, this.myIP);
            this.Application.cam1.flag_bt.enabled = false;
            return;
        }// end function

        public function reportUser2(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam2.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc_2 + " ha sido reportad@ como inapropiad@</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.myTooltip2.hide();
            this.reportedPPL.push(_loc_2);
            this.tracker.trackPageview("User Flagged");
            this.nc.call("flagThis", null, _loc_2, this.myIP);
            this.Application.cam2.flag_bt.enabled = false;
            return;
        }// end function

        public function reportUser3(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam3.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc_2 + " ha sido reportad@ como inapropiad@</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.myTooltip2.hide();
            this.reportedPPL.push(_loc_2);
            this.tracker.trackPageview("User Flagged");
            this.nc.call("flagThis", null, _loc_2, this.myIP);
            this.Application.cam3.flag_bt.enabled = false;
            return;
        }// end function

        public function EncryptStringRijndael55(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = new Rijndael();
            _loc_3 = _loc_2.encrypt(param1, this.rijndael_key5, "ECB");
            this.myIPencrypted = _loc_3;
            return;
        }// end function

        public function decryptStringRijndael5(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = new Rijndael();
            _loc_3 = _loc_2.decrypt(param1, this.rijndael_key5, "ECB");
            this.userIPdecrypted = _loc_3;
            return;
        }// end function

        public function closecam1()
        {
            this.play_ns.close();
            this.receiving_video = false;
            this.Application.cam1.visible = false;
            this.Application.cam1.cam1_wtxt.text = "";
            this.nc.call("watchingWho", null, null);
            return;
        }// end function

        public function closecam2()
        {
            this.play_ns2.close();
            this.receiving_video2 = false;
            this.Application.cam2.visible = false;
            this.Application.cam2.camname.text = "";
            this.Application.cam2.cam1_wtxt.text = "";
            return;
        }// end function

        public function closecam3()
        {
            this.play_ns3.close();
            this.receiving_video3 = false;
            this.Application.cam3.visible = false;
            this.Application.cam3.camname.text = "";
            this.Application.cam3.cam1_wtxt.text = "";
            return;
        }// end function

        public function manageStreams() : void
        {
            this.publish_ns = new NetStream(this.nc);
            this.play_ns = new NetStream(this.nc);
            this.play_ns.addEventListener(NetStatusEvent.NET_STATUS, this.videoStatusEvent);
            this.play_ns.client = this;
            this.play_ns2 = new NetStream(this.nc);
            this.play_ns2.addEventListener(NetStatusEvent.NET_STATUS, this.videoStatusEvent2);
            this.play_ns2.client = this;
            this.play_ns3 = new NetStream(this.nc);
            this.play_ns3.addEventListener(NetStatusEvent.NET_STATUS, this.videoStatusEvent3);
            this.play_ns3.client = this;
            return;
        }// end function

        public function videoStatusEvent(param1:Object) : void
        {
            if (param1.info.code == "NetStream.Buffer.Full")
            {
                this.soundXForm.volume = this.Application.cam1.volMC.volSlide.value;
                this.Application.cam1.load_anim.visible = false;
            }
            else if (param1.info.code == "NetStream.Play.Reset")
            {
                this.Application.cam1.video1.clear();
                this.Application.cam1.load_anim.visible = true;
                this.Application.cam1.flag_bt.enabled = true;
                this.Application.cam1.likeCam.enabled = true;
                this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser);
            }
            else if (param1.info.code == "NetStream.Play.UnpublishNotify")
            {
                this.closecam1();
            }
            else if (param1.info.code == "NetStream.Buffer.Empty")
            {
                this.Application.cam1.load_anim.visible = true;
            }
            return;
        }// end function

        public function videoStatusEvent2(param1:Object) : void
        {
            if (param1.info.code == "NetStream.Buffer.Full")
            {
                this.soundXForm2.volume = this.Application.cam2.volMC.volSlide.value;
                this.Application.cam2.load_anim.visible = false;
            }
            else if (param1.info.code == "NetStream.Play.Reset")
            {
                this.Application.cam2.videoObject.clear();
                this.Application.cam2.load_anim.visible = true;
                this.Application.cam2.flag_bt.enabled = true;
                this.Application.cam2.likeCam.enabled = true;
                this.Application.cam2.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser2);
            }
            else if (param1.info.code == "NetStream.Play.UnpublishNotify")
            {
                this.closecam2();
            }
            else if (param1.info.code == "NetStream.Buffer.Empty")
            {
            }
            return;
        }// end function

        public function videoStatusEvent3(param1:Object) : void
        {
            if (param1.info.code == "NetStream.Buffer.Full")
            {
                this.soundXForm3.volume = this.Application.cam3.volMC.volSlide.value;
                this.Application.cam3.load_anim.visible = false;
            }
            else if (param1.info.code == "NetStream.Play.Reset")
            {
                this.Application.cam3.videoObject.clear();
                this.Application.cam3.load_anim.visible = true;
                this.Application.cam3.flag_bt.enabled = true;
                this.Application.cam3.likeCam.enabled = true;
                this.Application.cam3.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser3);
            }
            else if (param1.info.code == "NetStream.Play.UnpublishNotify")
            {
                this.closecam3();
            }
            else if (param1.info.code == "NetStream.Buffer.Empty")
            {
            }
            return;
        }// end function

        public function HandleMouseOver(event:MouseEvent)
        {
            this.Application.cam1.volMC.visible = true;
            this.Application.cam1.close_bt.visible = true;
            this.Application.cam1.invite_bt.visible = true;
            this.Application.cam1.flag_bt.visible = true;
            this.Application.cam1.underbutt.visible = true;
            this.Application.cam1.likeCam.visible = true;
            return;
        }// end function

        public function HandleMouseOut(event:MouseEvent)
        {
            this.Application.cam1.volMC.visible = false;
            this.Application.cam1.close_bt.visible = false;
            this.Application.cam1.invite_bt.visible = false;
            this.Application.cam1.flag_bt.visible = false;
            this.Application.cam1.underbutt.visible = false;
            this.Application.cam1.likeCam.visible = false;
            return;
        }// end function

        public function HandleMouseOver2(event:MouseEvent)
        {
            this.Application.cam2.volMC.visible = true;
            this.Application.cam2.close_bt.visible = true;
            this.Application.cam2.invite_bt.visible = true;
            this.Application.cam2.flag_bt.visible = true;
            this.Application.cam2.underbutt.visible = true;
            this.Application.cam2.likeCam.visible = true;
            return;
        }// end function

        public function HandleMouseOut2(event:MouseEvent)
        {
            this.Application.cam2.volMC.visible = false;
            this.Application.cam2.close_bt.visible = false;
            this.Application.cam2.invite_bt.visible = false;
            this.Application.cam2.flag_bt.visible = false;
            this.Application.cam2.underbutt.visible = false;
            this.Application.cam2.likeCam.visible = false;
            return;
        }// end function

        public function HandleMouseOver3(event:MouseEvent)
        {
            this.Application.cam3.volMC.visible = true;
            this.Application.cam3.close_bt.visible = true;
            this.Application.cam3.invite_bt.visible = true;
            this.Application.cam3.flag_bt.visible = true;
            this.Application.cam3.underbutt.visible = true;
            this.Application.cam3.likeCam.visible = true;
            return;
        }// end function

        public function HandleMouseOut3(event:MouseEvent)
        {
            this.Application.cam3.volMC.visible = false;
            this.Application.cam3.close_bt.visible = false;
            this.Application.cam3.invite_bt.visible = false;
            this.Application.cam3.flag_bt.visible = false;
            this.Application.cam3.underbutt.visible = false;
            this.Application.cam3.likeCam.visible = false;
            return;
        }// end function

        public function playStream(param1:String, param2:String, param3:String) : void
        {
            this.nc.call("askCam", null, param1, this.myIPencrypted);
            if (this.receiving_video2 == true && this.receiving_video3 == true)
            {
                this.receiving_video = false;
            }
            if (this.receiving_video == false && param1 != this.Application.cam1.cam1_wtxt.text && param1 != this.Application.cam2.cam1_wtxt.text && param1 != this.Application.cam3.cam1_wtxt.text)
            {
                this.play_ns.close();
                this.nc.call("watchingWho", null, param1);
                if (this.imgLoad == true)
                {
                    this.imageLoader.unload();
                    this.Application.cam1.flagArea.removeChild(this.imageLoader);
                    this.imgLoad = false;
                }
                if (param3 == "España")
                {
                    param3 = "Spain";
                }
                this.loadImage(param3);
                this.Application.cam1.visible = true;
                this.Application.cam1.load_anim.visible = true;
                this.play_ns.soundTransform = this.soundXForm;
                if (this.mobileStream)
                {
                    this.Application.cam1.video1.visible = false;
                    this.Application.cam1.video1m.visible = true;
                    this.Application.cam1.video1m.attachNetStream(this.play_ns);
                }
                if (!this.mobileStream)
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
            else if (this.receiving_video == true && param1 != this.Application.cam1.cam1_wtxt.text && param1 != this.Application.cam2.cam1_wtxt.text && param1 != this.Application.cam3.cam1_wtxt.text && this.receiving_video2 == false)
            {
                this.play_ns2.close();
                this.receiving_video2 = true;
                this.Application.cam2.visible = true;
                this.Application.cam2.load_anim.visible = true;
                this.Application.cam2.cam1_wtxt.text = param1;
                if (this.imgLoad2 == true)
                {
                    this.imageLoader2.unload();
                    this.Application.cam2.flagArea.removeChild(this.imageLoader2);
                    this.imgLoad2 = false;
                }
                if (param3 == "España")
                {
                    param3 = "Spain";
                }
                this.loadImage2(param3);
                this.play_ns2.bufferTime = 1;
                this.play_ns2.soundTransform = this.soundXForm2;
                if (this.mobileStream)
                {
                    this.Application.cam2.videoObject.visible = false;
                    this.Application.cam2.videoObject2.visible = true;
                    this.Application.cam2.videoObject2.attachNetStream(this.play_ns2);
                }
                if (!this.mobileStream)
                {
                    this.Application.cam2.videoObject.visible = true;
                    this.Application.cam2.videoObject2.visible = false;
                    this.Application.cam2.videoObject.attachNetStream(this.play_ns2);
                }
                this.Application.cam2.camname.text = param1 + ", " + param2;
                this.play_ns2.play(param1);
            }
            else if (this.receiving_video2 == true && param1 != this.Application.cam1.cam1_wtxt.text && param1 != this.Application.cam2.cam1_wtxt.text && param1 != this.Application.cam3.cam1_wtxt.text && this.receiving_video3 == false)
            {
                this.play_ns3.close();
                this.receiving_video3 = true;
                this.Application.cam3.visible = true;
                this.Application.cam3.load_anim.visible = true;
                this.Application.cam3.cam1_wtxt.text = param1;
                if (this.imgLoad3 == true)
                {
                    this.imageLoader3.unload();
                    this.Application.cam3.flagArea.removeChild(this.imageLoader3);
                    this.imgLoad3 = false;
                }
                if (param3 == "España")
                {
                    param3 = "Spain";
                }
                this.loadImage3(param3);
                this.play_ns3.bufferTime = 1;
                this.play_ns3.soundTransform = this.soundXForm3;
                if (this.mobileStream)
                {
                    this.Application.cam3.videoObject.visible = false;
                    this.Application.cam3.videoObject2.visible = true;
                    this.Application.cam3.videoObject2.attachNetStream(this.play_ns3);
                }
                if (!this.mobileStream)
                {
                    this.Application.cam3.videoObject.visible = true;
                    this.Application.cam3.videoObject2.visible = false;
                    this.Application.cam3.videoObject.attachNetStream(this.play_ns3);
                }
                this.Application.cam3.camname.text = param1 + ", " + param2;
                this.play_ns3.play(param1);
            }
            return;
        }// end function

        public function volChange(event:SliderEvent) : void
        {
            if (event.value == 0)
            {
                this.Application.cam1.volMC.muteIcon.visible = true;
            }
            else if (event.value != 0)
            {
                this.Application.cam1.volMC.muteIcon.visible = false;
            }
            this.soundXForm.volume = event.value;
            this.play_ns.soundTransform = this.soundXForm;
            return;
        }// end function

        public function volChange2(event:SliderEvent) : void
        {
            if (event.value == 0)
            {
                this.Application.cam2.volMC.muteIcon.visible = true;
            }
            else if (event.value != 0)
            {
                this.Application.cam2.volMC.muteIcon.visible = false;
            }
            this.soundXForm2.volume = event.value;
            this.play_ns2.soundTransform = this.soundXForm2;
            return;
        }// end function

        public function volChange3(event:SliderEvent) : void
        {
            if (event.value == 0)
            {
                this.Application.cam3.volMC.muteIcon.visible = true;
            }
            else if (event.value != 0)
            {
                this.Application.cam3.volMC.muteIcon.visible = false;
            }
            this.soundXForm3.volume = event.value;
            this.play_ns3.soundTransform = this.soundXForm3;
            return;
        }// end function

        public function onTimeUp(event:TimerEvent) : void
        {
            this.doSyncOnce = true;
            return;
        }// end function

        public function onTimeUp888(event:TimerEvent) : void
        {
            this.updatePeopleList();
            return;
        }// end function

        public function manageSO() : void
        {
            this.users_so = SharedObject.getRemote("users_so", this.nc.uri, false);
            this.chat_so = SharedObject.getRemote("chat_so", this.nc.uri, false);
            this.rooms_so = SharedObject.getRemote("public/roomsAndUsers", this.nc.uri, true);
            this.rooms_so.addEventListener(SyncEvent.SYNC, this.syncEventHandler);
            this.users_so.connect(this.nc);
            this.rooms_so.connect(this.nc);
            this.chat_so.connect(this.nc);
            this.chat_so.client = this;
            this.users_so.client = this;
            this.rooms_so.client = this;
            this.doSyncOnce = true;
            this.updateTimer67.start();
            return;
        }// end function

        public function syncEventHandler(event:SyncEvent)
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            if (this.doSyncOnce)
            {
                this.roomsDP.removeAll();
                for (_loc_2 in this.rooms_so.data)
                {
                    
                    if (_loc_6[_loc_2] != null)
                    {
                        _loc_3 = _loc_6[_loc_2];
                        _loc_4 = "room_icon";
                        if (_loc_3.password != "")
                        {
                            _loc_4 = "key_mc";
                        }
                        if (_loc_3.roomUsers > 99)
                        {
                            _loc_4 = "hotroom_icon";
                        }
                        if (_loc_3.roomUsers < 20 && _loc_3.password == "")
                        {
                            _loc_4 = "coldroom_icon";
                        }
                        if (_loc_3.roomVip == true)
                        {
                            _loc_4 = "viproom_icon";
                        }
                        if (_loc_3.autoRoom == true)
                        {
                            _loc_4 = "heart_mc";
                        }
                        if (_loc_3.roomName != "" && _loc_3.autoRoom == true)
                        {
                            this.roomsDP.addItem({label:"Privado (2)", icon:_loc_4, owner:"admin", topic:"", lock:"94uwjjrs92845hwos083hj5w0eips0w4ji54st46464ss", sorted:_loc_3.sortRoom});
                            this.roomsDP.sortOn(["sorted", "lock"]);
                        }
                        else
                        {
                            this.roomsDP.addItem({label:_loc_3.roomName + " (" + _loc_3.roomUsers + ")", data:_loc_3.roomID, nombre:_loc_3.roomName, icon:_loc_4, owner:_loc_3.owner, topic:_loc_3.roomTopic, lock:_loc_3.password, roomUserCount:_loc_3.roomUsers, vipRoom:_loc_3.roomVip, autoRoom:_loc_3.autoRoom, sorted:_loc_3.sortRoom, roomLimit:_loc_3.roomLimit, roomObj:_loc_3});
                            this.roomsDP.sortOn(["sorted", "lock"]);
                        }
                        this.doSyncOnce = false;
                        this.updateTimer.start();
                    }
                }
            }
            return;
        }// end function

        public function updatePeopleList() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            this.usersDP.removeAll();
            for (_loc_1 in this.users_so.data)
            {
                
                if (_loc_4[_loc_1] != null)
                {
                    _loc_2 = _loc_4[_loc_1];
                    if (_loc_2.UserName == this.Application.cam1.cam1_wtxt.text)
                    {
                        this.Application.cam1.likeCam.label = _loc_2.votesUp.toString();
                    }
                    if (_loc_2.UserName == this.Application.cam2.cam1_wtxt.text)
                    {
                        this.Application.cam2.likeCam.label = _loc_2.votesUp.toString();
                    }
                    if (_loc_2.UserName == this.Application.cam3.cam1_wtxt.text)
                    {
                        this.Application.cam3.likeCam.label = _loc_2.votesUp.toString();
                    }
                    if (this.Application.optionsMC.userCheck.selected == true)
                    {
                        if (_loc_2.userstatus == "idle")
                        {
                            this.usersDP.addItem({label:_loc_2.UserName, data:_loc_2.UserName, gender:_loc_2.gender, streaming:_loc_2.userstatus, camtype:_loc_2.camtype, iswatching:_loc_2.iswatching, pais:_loc_2.pais, ip2:_loc_2.ip2, likes:_loc_2.votes, age:_loc_2.age, isMobile:_loc_2.mobileUser, vipCam:_loc_2.vipCam});
                            this.usersDP.sortOn([this.listStatus, "gender", "label"], [Array.DESCENDING, Array.CASEINSENSITIVE]);
                        }
                        continue;
                    }
                    this.usersDP.addItem({label:_loc_2.UserName, data:_loc_2.UserName, gender:_loc_2.gender, streaming:_loc_2.userstatus, camtype:_loc_2.camtype, iswatching:_loc_2.iswatching, pais:_loc_2.pais, ip2:_loc_2.ip2, likes:_loc_2.votes, age:_loc_2.age, isMobile:_loc_2.mobileUser, vipCam:_loc_2.vipCam});
                    this.usersDP.sortOn([this.listStatus, "gender", "label"], [Array.DESCENDING, Array.CASEINSENSITIVE]);
                }
            }
            return;
        }// end function

        public function changeRoom(event:Event) : void
        {
            var _loc_2:* = event.target.selectedItem.data;
            this.roomID = _loc_2;
            var _loc_3:* = event.target.selectedItem.lock;
            var _loc_4:* = event.target.selectedItem.roomUserCount;
            var _loc_5:* = event.target.selectedItem.vipRoom;
            this.goingToRoom = event.target.selectedItem.nombre;
            var _loc_6:* = event.target.selectedItem.roomLimit;
            var _loc_7:* = event.target.selectedItem.owner;
            var _loc_8:* = event.target.selectedItem.autoRoom;
            if (_loc_2 == this.currentRoomID)
            {
                return;
            }
            if (_loc_2 == null)
            {
                return;
            }
            if (this.roomTitle == this.goingToRoom)
            {
                return;
            }
            if (event.target.selectedItem.data == undefined)
            {
                return;
            }
            if (_loc_3 == "94uwjjrs92845hwos083hj5w0eips0w4ji54st46464ss")
            {
                return;
            }
            if (_loc_3 != "" && !_loc_8)
            {
                this.tempPW = _loc_3;
                this.Application.filters = [this.bf];
                this.enterRoomMC.visible = true;
                this.enterRoomMC.claveSala.setFocus();
                return;
            }
            this.nc.call("roomDest", null, this.goingToRoom);
            this.changingRoom = true;
            this.Application.people_lb.removeAll();
            this.Application.people_lb.addItem({label:"Cargando.."});
            this.Application.History.htmlText = "";
            this.doDisconnect();
            this.tracker.trackPageview("Room Change To: " + this.goingToRoom);
            this.connectApp();
            return;
        }// end function

        public function doSendPV(event:MouseEvent) : void
        {
            this.sendPVMsg();
            return;
        }// end function

        public function sendPVMsg() : void
        {
            var _loc_4:* = undefined;
            var _loc_1:* = this.Application.mensPv.pv_msg.text;
            var _loc_2:* = this.curSelectionUser;
            var _loc_3:* = "#0000FF";
            if (_loc_1 != "" && this.curSelectionUser != null)
            {
                this.Application.mensPv.pv_msg.text = "";
                this.nc.call("msgFromClient", null, _loc_1, _loc_3, _loc_2, this.myIPencrypted);
                _loc_4 = "<font face=\'Tahoma\' size=\'15\' color=\'#0000FF\'><b>MP para " + _loc_2 + ": </b></font> <font face=\'Tahoma\' size=\'15\' color=\'#FF0000\'><b>" + _loc_1 + "</b></font>";
                this.Application.History.htmlText = this.Application.History.htmlText + _loc_4;
            }
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function doSend(event:MouseEvent) : void
        {
            this.sendMsg();
            return;
        }// end function

        public function sendMsg() : void
        {
            var _loc_1:* = this.Application.msg.htmlText;
            var _loc_2:* = this.Application.msg.text;
            if (_loc_1 != "")
            {
                this.nc.call("chatMember", null, _loc_1, this.myName, this.myColor, this.myIPencrypted, this.Eql9844kmgldiroURrX998q12Vgm, _loc_2);
                this.Application.msg.text = "";
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            }
            return;
        }// end function

        public function onTextSelect(event:FocusEvent) : void
        {
            this.Application.fontSel.visible = false;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function keyDownHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == 13)
            {
                this.sendMsg();
                this.sendPVMsg();
            }
            return;
        }// end function

        public function doDisconnect() : void
        {
            this.closecam1();
            this.closecam2();
            this.closecam3();
            this.closePVwin();
            this.nc.close();
            return;
        }// end function

        public function selectedUser(event:Event) : void
        {
            this.curSelectionUser = event.target.selectedItem.label;
            this.theWho = this.curSelectionUser;
            var _loc_2:* = event.target.selectedItem.streaming;
            var _loc_3:* = event.target.selectedItem.age;
            var _loc_4:* = event.target.selectedItem.pais;
            var _loc_5:* = event.target.selectedItem.vipCam;
            var _loc_6:* = event.target.selectedItem.likes;
            this.mobileStream = event.target.selectedItem.isMobile;
            this.Application.msg.setFocus();
            this.Application.mensPv.toWhoPV.htmlText = "<font color=\'#000000\'>Mensaje privado para:</font> <font color=\'#FF0000\'>" + this.curSelectionUser + "</font>";
            this.Application.mensPv.visible = true;
            this.Application.History.y = 344;
            this.Application.History.height = 237;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            if (this.curSelectionUser == this.myName)
            {
                this.theWho = undefined;
                this.closePVwin();
                return;
            }
            if (this.curSelectionUser == this.Application.cam1.cam1_wtxt.text)
            {
                this.Application.mensPv.visible = true;
                this.Application.History.y = 344;
                this.Application.History.height = 237;
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            if (_loc_2 == "idle")
            {
                this.playStream(this.curSelectionUser, _loc_3, _loc_4);
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            }
            return;
        }// end function

        public function closePV(event:MouseEvent)
        {
            this.closePVwin();
            return;
        }// end function

        public function closePVwin() : void
        {
            this.tracker.trackPageview("PV WINDOW CLOSED");
            this.Application.mensPv.visible = false;
            this.Application.mensPv.pv_msg.text = "";
            this.Application.History.y = 265;
            this.Application.History.height = 316;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function showLogout(event:MouseEvent) : void
        {
            this.Application.myTooltip.content = "Cerrar sesión";
            this.Application.myTooltip.show();
            return;
        }// end function

        public function hideLogout(event:MouseEvent) : void
        {
            this.Application.myTooltip.hide();
            return;
        }// end function

        public function showFlagTip(event:MouseEvent) : void
        {
            this.Application.myTooltip2.type = "image";
            this.Application.myTooltip2.content = myMC;
            this.Application.myTooltip2.show();
            return;
        }// end function

        public function hideFlagTip(event:MouseEvent) : void
        {
            this.Application.myTooltip2.hide();
            return;
        }// end function

        public function showCreateTip(event:MouseEvent) : void
        {
            this.Application.myTooltip.content = "Crear y Moderar Sala de VideoChat";
            this.Application.myTooltip.show();
            return;
        }// end function

        public function hideCreateTip(event:MouseEvent) : void
        {
            this.Application.myTooltip.hide();
            return;
        }// end function

        public function showInviteTip(event:MouseEvent) : void
        {
            this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam1.cam1_wtxt.text + "</b> a una sala privada";
            this.Application.myTooltip.show();
            return;
        }// end function

        public function showInviteTip2(event:MouseEvent) : void
        {
            this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam2.cam1_wtxt.text + "</b> a una sala privada";
            this.Application.myTooltip.show();
            return;
        }// end function

        public function showInviteTip3(event:MouseEvent) : void
        {
            this.Application.myTooltip.content = "Invitar a <b>" + this.Application.cam3.cam1_wtxt.text + "</b> a una sala privada";
            this.Application.myTooltip.show();
            return;
        }// end function

        public function hideInviteTip(event:MouseEvent) : void
        {
            this.Application.myTooltip.hide();
            return;
        }// end function

        public function showUserInfo(event:ListEvent) : void
        {
            var _loc_2:* = this.Application.people_lb.getItemAt(event.index).ip2;
            var _loc_3:* = this.Application.people_lb.getItemAt(event.index).vipCam;
            var _loc_4:* = this.Application.people_lb.getItemAt(event.index).age;
            var _loc_5:* = this.Application.people_lb.getItemAt(event.index).pais;
            var _loc_6:* = this.Application.people_lb.getItemAt(event.index).iswatching;
            var _loc_7:* = this.Application.people_lb.getItemAt(event.index).camtype;
            if (_loc_4 < 18)
            {
                _loc_4 = 18;
            }
            this.Application.myTooltip.content = "Pais: <b>" + _loc_5 + "</b><br>Edad: <b>" + _loc_4 + "</b>";
            if (_loc_4 != undefined)
            {
                this.Application.myTooltip.show();
            }
            return;
        }// end function

        public function showRoomInfo(event:ListEvent) : void
        {
            this.Application.myTooltip.hide();
            var _loc_2:* = this.Application.rooms_lb.getItemAt(event.index).owner;
            var _loc_3:* = this.Application.rooms_lb.getItemAt(event.index).icon;
            var _loc_4:* = this.Application.rooms_lb.getItemAt(event.index).topic;
            this.Application.myTooltip.content = "Moderador:  <b>" + _loc_2 + "</b><br>" + _loc_4;
            if (_loc_2 != "admin")
            {
                this.Application.myTooltip.show();
            }
            if (_loc_3 == "key_mc" && this.stealthmode == false)
            {
                this.Application.myTooltip.hide();
            }
            else if (_loc_2 == "admin")
            {
                this.Application.myTooltip.hide();
            }
            return;
        }// end function

        public function hideUserInfo(event:ListEvent) : void
        {
            this.Application.myTooltip.hide();
            return;
        }// end function

        public function ignoTip(param1:String) : void
        {
            this.Application.myTooltip.content = param1;
            this.Application.myTooltip.show();
            this.myTimer.start();
            return;
        }// end function

        public function hideIgnoTip(event:TimerEvent) : void
        {
            this.Application.myTooltip.hide();
            return;
        }// end function

        public function showLevel(event:Event) : void
        {
            this.Application.myCamMC.micMeter.colorBar.height = this.mic.activityLevel * 0.875;
            return;
        }// end function

        public function setMicLevel(event:SliderEvent) : void
        {
            this.mic.gain = event.value;
            this.tracker.trackPageview("VOLUME CHANGED");
            return;
        }// end function

        public function cameraHandler(event:MouseEvent) : void
        {
            var _loc_2:* = undefined;
            if (this.timeOut == true)
            {
                this.tracker.trackPageview("StartCam Clicked but TimedOut :(");
                _loc_2 = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>Tu tiempo de videochat gratis ha terminado, <font color=\'#0000FF\'><u><a href=\'http://www.chatvideo.es/reg.html\'>Regístrate</a></u></font> para acceso sin límites!</font>";
                this.Application.History.htmlText = this.Application.History.htmlText + _loc_2;
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                this.Application.activateCam.selected = false;
                this.showRegAlert("Tu tiempo de videochat gratis ha terminado<br>Regístrate para acceso total!");
                return;
            }
            if (this.camTimeUp == true)
            {
                this.tracker.trackPageview("MALE SEND CAM TIMEUP");
                this.showRegAlert("Regístrate para activar tu camara sin límite de tiempo!");
                this.Application.activateCam.selected = false;
                return;
            }
            if (event.target.selected == true)
            {
                this.startCam();
            }
            else
            {
                this.stopCam();
            }
            return;
        }// end function

        public function bellHandler(event:MouseEvent) : void
        {
            if (event.target.selected == true)
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
            return;
        }// end function

        public function vipCamHandler(event:MouseEvent) : void
        {
            if (event.target.selected == true)
            {
                this.tracker.trackPageview("USER SET WEBCAM TO VIP");
                this.nc.call("updatevipCamStatus", null, event.target.selected);
            }
            else
            {
                this.nc.call("updatevipCamStatus", null, event.target.selected);
            }
            return;
        }// end function

        public function micHandler(event:MouseEvent) : void
        {
            var event:* = event;
            var cameraHandler:* = function (event:MouseEvent) : void
            {
                if (event.target.selected == true)
                {
                    startCam();
                }
                else
                {
                    stopCam();
                }
                return;
            }// end function
            ;
            if (event.target.selected == true)
            {
                this.startMic();
            }
            else
            {
                this.stopMic();
            }
            return;
        }// end function

        public function startMic() : void
        {
            this.mic = Microphone.getMicrophone();
            if (this.mic)
            {
                this.mic.setSilenceLevel(0);
                this.mic.codec = SoundCodec.SPEEX;
                this.mic.enableVAD = false;
                this.mic.gain = this.Application.myCamMC.micVol.value;
                this.mic.encodeQuality = this.micQ;
                stage.addEventListener(Event.ENTER_FRAME, this.showLevel);
                this.mic_on = true;
                this.publish_ns.attachAudio(this.mic);
                this.tracker.trackPageview("MIC STARTED");
                this.Application.activateMic.selected = true;
            }
            this.Application.myCamMC.micVol.visible = true;
            this.Application.myCamMC.micIcon1.visible = true;
            this.Application.myCamMC.micMeter.visible = true;
            return;
        }// end function

        public function stopMic() : void
        {
            this.mic.gain = 0;
            this.mic_on = false;
            this.Application.myCamMC.micVol.visible = false;
            this.Application.myCamMC.micIcon1.visible = false;
            this.Application.myCamMC.micMeter.visible = false;
            stage.removeEventListener(Event.ENTER_FRAME, this.showLevel);
            this.tracker.trackPageview("MIC STOPPED");
            return;
        }// end function

        public function stopCam() : void
        {
            this.fakeTimer.stop();
            this.publish_ns.close();
            this.Application.myCamMC.visible = false;
            this.nc.call("updateStatus", null, "online");
            this.sending_video = false;
            this.Application.myCamMC.myCam.attachCamera(null);
            this.publish_ns.attachCamera(null);
            this.Application.activateMic.enabled = false;
            this.Application.activateMic.selected = false;
            this.Application.activateCam.selected = false;
            this.Application.myCamMC.micVol.visible = false;
            this.Application.myCamMC.micIcon1.visible = false;
            this.Application.myCamMC.micMeter.visible = false;
            return;
        }// end function

        public function startCam() : void
        {
            this.cam = Camera.getCamera();
            if (Camera.names.length > 0)
            {
                if (this.camTimeUp == true)
                {
                    this.stopCam();
                    return;
                }
                this.publish_ns = new NetStream(this.nc);
                this.publish_ns.videoStreamSettings = this.h264Config;
                this.h264Config.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_1);
                this.deviceName = this.cam.name;
                this.cam.addEventListener(StatusEvent.STATUS, this.camStatusHandler);
                this.tracker.trackPageview("CAMERA FOUND: " + this.deviceName);
                this.cam.setQuality(this.camQ, 0);
                this.cam.setMode(320, 240, this.camFPS);
                this.cam.setKeyFrameInterval(48);
                this.Application.myCamMC.myCam.attachCamera(this.cam);
                this.Application.myCamMC.visible = true;
                this.publish_ns.attachCamera(this.cam);
                this.publish_ns.publish(this.myName, "live");
                this.Application.myCamMC.micMeter.visible = false;
                this.Application.activateMic.enabled = true;
                this.Application.activateCam.selected = true;
                this.nc.call("updatevipCamStatus", null, this.Application.optionsMC.vipCheck.selected);
                this.nc.call("updateCamStatus", null, this.deviceName);
                this.nc.call("updateStatus", null, "idle");
                this.nc.call("updateMyVotes", null, this.local_so.data.myVotes);
                this.sending_video = true;
                this.startMic();
                this.tracker.trackPageview("CAM STARTED");
                this.fakeTimer.start();
                if (this.cam.muted)
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
            return;
        }// end function

        public function camStatusHandler(event:StatusEvent) : void
        {
            this.tracker.trackPageview(event.code);
            if (Camera.names.length > 0)
            {
                this.tracker.trackPageview(event.code);
                if (event.code == "Camera.Muted")
                {
                    this.stopCam();
                }
                else
                {
                    if (this.timeOut == true)
                    {
                        return;
                    }
                    this.Application.activateCam.selected = true;
                    this.Application.activateMic.enabled = true;
                    this.Application.myCamMC.visible = true;
                    this.startCam();
                }
            }
            return;
        }// end function

        public function badCamsError(event:IOErrorEvent) : void
        {
            this.tracker.trackPageview("Error al cargar badCams.txt");
            return;
        }// end function

        public function onBadCamsLoaded(event:Event) : void
        {
            this.bannedDevices = event.target.data.split(",");
            return;
        }// end function

        public function fakeTick(event:TimerEvent)
        {
            if (this.timeOut == true)
            {
                this.stopCam();
            }
            if (this.deviceName == null)
            {
                return;
            }
            if (this.sending_video == true)
            {
                this.startsWith(this.deviceName, this.bannedDevices, 6);
            }
            return;
        }// end function

        public function startsWith(param1:String, param2:Array, param3:uint) : Array
        {
            var _loc_5:* = null;
            var _loc_6:* = undefined;
            var _loc_4:* = [];
            for each (_loc_5 in param2)
            {
                
                if (_loc_5.match("^" + param1.substr(0, param3)))
                {
                    this.stopCam();
                    _loc_6 = "<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>* Por favor selecciona otra cámara, </font><font color=\'#000000\'>" + param1 + "</font><font color=\'#FF0000\'> no es compatible con ChatVideo</font>";
                    this.Application.History.htmlText = this.Application.History.htmlText + _loc_6;
                    this.tracker.trackPageview("BANNED DEVICE: " + param1);
                    this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                    Security.showSettings(SecurityPanel.CAMERA);
                    _loc_4.push(_loc_5);
                }
            }
            return _loc_4;
        }// end function

        public function showCamConf(event:MouseEvent) : void
        {
            Security.showSettings(SecurityPanel.CAMERA);
            return;
        }// end function

        public function doLogout(event:MouseEvent) : void
        {
            this.changingRoom = true;
            this.Application.visible = false;
            this.doDisconnect();
            this.showAlerts("<br><br>Sesión Terminada.<br><br>");
            return;
        }// end function

        public function createNR(event:MouseEvent) : void
        {
            var i:*;
            var goNewRoom:Function;
            var roomObject:*;
            var roomErrMessg:*;
            var Event:* = event;
            goNewRoom = function () : void
            {
                Application.History.htmlText = "";
                doDisconnect();
                connectApp();
                return;
            }// end function
            ;
            if (this.newRmc.newRN.text == "")
            {
                this.newRmc.newRN.setFocus();
                return;
            }
            if (this.newRmc.newRD.text == "")
            {
                this.newRmc.newRD.setFocus();
                return;
            }
            if (this.newRmc.newRN.text == "Privado")
            {
                this.newRmc.newRN.setFocus();
                this.newRmc.newRN.text = "";
                return;
            }
            var _loc_3:* = 0;
            var _loc_4:* = this.rooms_so.data;
            while (_loc_4 in _loc_3)
            {
                
                i = _loc_4[_loc_3];
                if (_loc_4[i] != null)
                {
                    roomObject = _loc_4[i];
                    if (roomObject.owner == this.Eql9844kmgldiroURrX998q12Vgm)
                    {
                        roomErrMessg;
                        this.Application.History.htmlText = this.Application.History.htmlText + roomErrMessg;
                        this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                        this.closeWinNR();
                        return;
                    }
                }
            }
            if (this.newRmc.newRP.text != "")
            {
                this.EncryptStringRijndael();
            }
            var nrTimer:* = new Timer(800, 1);
            nrTimer.addEventListener(TimerEvent.TIMER, goNewRoom);
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
            this.rooms_so.setProperty(roomObj.roomID, roomObj);
            this.roomID = roomObj.roomID;
            this.sendRoomKey = roomObj.password;
            this.changingRoom = true;
            this.tracker.trackPageview("USER_CREATED_ROOM:_" + this.roomID);
            nrTimer.start();
            var msgDest:* = this.myName + " se ha ido a " + roomObj.roomName;
            this.myRoomPW = "";
            this.closeWinNR();
            return;
        }// end function

        public function closeNR(event:MouseEvent) : void
        {
            this.closeWinNR();
            return;
        }// end function

        public function closeWinNR() : void
        {
            this.newRmc.visible = false;
            this.newRmc.newRN.text = "";
            this.newRmc.newRD.text = "";
            this.newRmc.newRP.text = "";
            this.Application.filters = null;
            this.Application.msg.setFocus();
            return;
        }// end function

        public function createRoomHandler(event:MouseEvent) : void
        {
            this.Application.filters = [this.bf];
            this.newRmc.visible = true;
            this.newRmc.newRN.setFocus();
            return;
        }// end function

        public function enterPWroom(event:MouseEvent) : void
        {
            if (this.enterRoomMC.claveSala.text == "")
            {
                this.enterRoomMC.badpwd.visible = false;
                this.enterRoomMC.claveSala.setFocus();
                return;
            }
            this.decryptStringRijndael();
            return;
        }// end function

        public function enterPWroomClose(event:MouseEvent) : void
        {
            this.enterRoomMC.visible = false;
            this.enterRoomMC.badpwd.visible = false;
            this.Application.filters = null;
            this.Application.msg.setFocus();
            return;
        }// end function

        public function EncryptStringRijndael() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = new Rijndael();
            _loc_2 = _loc_1.encrypt(this.newRmc.newRP.text, this.rijndael_key, "ECB");
            this.myRoomPW = _loc_2;
            return;
        }// end function

        public function decryptStringRijndael() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = new Rijndael();
            _loc_2 = _loc_1.encrypt(this.enterRoomMC.claveSala.text, this.rijndael_key, "ECB");
            if (_loc_2 != this.tempPW)
            {
                this.enterRoomMC.claveSala.text = "";
                this.enterRoomMC.badpwd.visible = true;
                this.enterRoomMC.claveSala.setFocus();
                this.tracker.trackPageview("WRONG_ROOM_PASSWORD");
                return;
            }
            if (_loc_2 == this.tempPW)
            {
                this.keyRoomStr = _loc_2;
                this.tracker.trackPageview("CORRECT_ROOM_PASSWORD!");
                this.enterRoomMC.visible = false;
                this.enterRoomMC.badpwd.visible = false;
                this.changingRoom = true;
                this.Application.people_lb.removeAll();
                this.Application.people_lb.addItem({label:"Cargando..."});
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
                return;
            }
            return;
        }// end function

        public function runInvite(event:MouseEvent) : void
        {
            this.inviteToWho = this.Application.cam1.cam1_wtxt.text;
            this.sendInvite();
            return;
        }// end function

        public function runInvite2(event:MouseEvent) : void
        {
            this.inviteToWho = this.Application.cam2.cam1_wtxt.text;
            this.sendInvite();
            return;
        }// end function

        public function runInvite3(event:MouseEvent) : void
        {
            this.inviteToWho = this.Application.cam3.cam1_wtxt.text;
            this.sendInvite();
            return;
        }// end function

        public function runInvite4(event:MouseEvent) : void
        {
            this.inviteToWho = this.curSelectionUser;
            this.sendInvite();
            return;
        }// end function

        public function sendInvite() : void
        {
            var _loc_1:* = this.inviteToWho;
            if (_loc_1 == this.myName)
            {
                this.Application.History.htmlText = this.Application.History.htmlText + "<font face=\'Arial\' color=\'#ff0000\' size=\'12\'>* No te puedes invitar a ti mism@!</font>";
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            if (this.sendInvitation == false)
            {
                this.Application.History.htmlText = this.Application.History.htmlText + "<font face=\'Tahoma\' color=\'#FF0000\' size=\'12\'>* Espera unos segundos antes de enviar otra invitacion :-)</font>";
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            if (_loc_1 != undefined)
            {
                this.invitePV(_loc_1);
                this.sendInvitation = false;
                this.invTimer.start();
            }
            return;
        }// end function

        public function invitePV(param1:String) : void
        {
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' color=\'#0000FF\' size=\'12\'>* <font color=\'#FF0000\'>" + param1 + "</font> ha sido invitad@ a una sala privada...</font>");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.nc.call("invitePV", null, param1, this.myName, this.myIPencrypted);
            this.tracker.trackPageview("Invitation_Sent");
            return;
        }// end function

        public function pvTimer(event:TimerEvent) : void
        {
            this.sendInvitation = true;
            return;
        }// end function

        public function inviteAccept(param1:String) : void
        {
            this.tracker.trackPageview("InvitationAccepted");
            var _loc_2:* = new Timer(2000, 1);
            _loc_2.addEventListener(TimerEvent.TIMER, this.goPV2);
            var _loc_3:* = new Object();
            _loc_3.roomUsers = 0;
            _loc_3.roomName = "~PV" + this.generateRandomString(5);
            _loc_3.roomTopic = "privado";
            _loc_3.roomVip = false;
            _loc_3.sortRoom = 888888888 + this.generateRandomString(4);
            _loc_3.autoRoom = true;
            _loc_3.roomID = "room_" + this.generateRandomString(20);
            _loc_3.isPrivate = true;
            _loc_3.password = "********";
            _loc_3.owner = param1;
            this.rooms_so.setProperty(_loc_3.roomID, _loc_3);
            this.roomID = _loc_3.roomID;
            this.changingRoom = true;
            this.nc.call("goPV", null, param1, this.roomID);
            _loc_2.start();
            return;
        }// end function

        public function goPV2(event:TimerEvent) : void
        {
            this.Application.History.htmlText = "";
            this.doDisconnect();
            this.connectApp();
            return;
        }// end function

        public function generateRandomString(param1:Number) : String
        {
            var _loc_2:* = "abcdefghijklmnopqrstuvwxyz0123456789";
            var _loc_3:* = _loc_2.length - 1;
            var _loc_4:* = "";
            var _loc_5:* = 0;
            while (_loc_5 < param1)
            {
                
                _loc_4 = _loc_4 + _loc_2.charAt(Math.floor(Math.random() * _loc_3));
                _loc_5 = _loc_5 + 1;
            }
            return _loc_4;
        }// end function

        public function loadImage(param1:String) : void
        {
            this.imageLoader = new Loader();
            this.imageLoader.load(new URLRequest(this.flagPath + param1 + ".png"));
            this.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.imageLoaded);
            return;
        }// end function

        public function imageLoaded(event:Event) : void
        {
            this.Application.cam1.flagArea.addChild(this.imageLoader);
            this.imgLoad = true;
            return;
        }// end function

        public function loadImage2(param1:String) : void
        {
            this.imageLoader2 = new Loader();
            this.imageLoader2.load(new URLRequest(this.flagPath + param1 + ".png"));
            this.imageLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.imageLoaded2);
            return;
        }// end function

        public function imageLoaded2(event:Event) : void
        {
            this.Application.cam2.flagArea.addChild(this.imageLoader2);
            this.imgLoad2 = true;
            return;
        }// end function

        public function loadImage3(param1:String) : void
        {
            this.imageLoader3 = new Loader();
            this.imageLoader3.load(new URLRequest(this.flagPath + param1 + ".png"));
            this.imageLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.imageLoaded3);
            return;
        }// end function

        public function imageLoaded3(event:Event) : void
        {
            this.Application.cam3.flagArea.addChild(this.imageLoader3);
            this.imgLoad3 = true;
            return;
        }// end function

        public function storeLocalSO() : void
        {
            var soStatus:Function;
            soStatus = function (event:NetStatusEvent) : void
            {
                if (event.info.code == "SharedObject.Flush.Failed")
                {
                }
                return;
            }// end function
            ;
            var flushStatus:String;
            try
            {
                flushStatus = this.local_so.flush(1000);
            }
            catch (error:Error)
            {
            }
            if (flushStatus != null)
            {
                this.local_so.data.myName = this.myName;
                this.local_so.data.myGender = this.myGender;
                this.local_so.data.myAge = this.myAge;
                this.local_so.flush();
                switch(flushStatus)
                {
                    case SharedObjectFlushStatus.PENDING:
                    {
                        this.local_so.addEventListener(NetStatusEvent.NET_STATUS, soStatus);
                        break;
                    }
                    case SharedObjectFlushStatus.FLUSHED:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        public function closeCamClick(event:MouseEvent) : void
        {
            this.closecam2();
            return;
        }// end function

        public function closeCamClick3(event:MouseEvent) : void
        {
            this.closecam3();
            return;
        }// end function

        public function mouseDownHandler4(event:MouseEvent) : void
        {
            this.Application.myCamMC.startDrag();
            this.tracker.trackPageview("DRAGGING_MY_CAM");
            return;
        }// end function

        public function mouseUpHandler4(event:MouseEvent) : void
        {
            this.Application.myCamMC.stopDrag();
            return;
        }// end function

        public function likeUser(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam1.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc_2 + "!</b></font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.nc.call("likeYou", null, _loc_2, this.myName);
            this.Application.cam1.likeCam.removeEventListener(MouseEvent.CLICK, this.likeUser);
            return;
        }// end function

        public function likeUser2(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam2.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc_2 + "!</b></font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.cam2.likeCam.removeEventListener(MouseEvent.CLICK, this.likeUser2);
            this.nc.call("likeYou", null, _loc_2, this.myName);
            return;
        }// end function

        public function likeUser3(event:MouseEvent) : void
        {
            var _loc_2:* = this.Application.cam3.cam1_wtxt.text;
            var _loc_3:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'15\'><b>Me gusta " + _loc_2 + "!</b></font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            this.Application.cam3.likeCam.removeEventListener(MouseEvent.CLICK, this.likeUser3);
            this.nc.call("likeYou", null, _loc_2, this.myName);
            return;
        }// end function

        public function likeMe(param1:String) : void
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.likeMeArray.length)
            {
                
                if (this.likeMeArray[_loc_2] == param1)
                {
                    return;
                }
                _loc_2 = _loc_2 + 1;
            }
            this.likeMeArray.push(param1);
            this.nc.call("setVoteUp", null, this.myIP);
            return;
        }// end function

        public function LCTest() : void
        {
            this.lc = new LocalConnection();
            this.lc.client = this;
            this.lc.allowDomain("*");
            try
            {
                this.lc.connect("_myLCLock");
            }
            catch (e:ArgumentError)
            {
                login_mc.visible = false;
                showAlerts("<br><br>ChatVideo esta abierto en otra ventana<br><br>");
            }
            return;
        }// end function

        private function connectApp() : void
        {
            if (this.firstLogon)
            {
                this.setFontTypeSO();
                this.login_mc.conn_anim.visible = true;
            }
            this.nc.connect(this.fms_gateway + this.roomID, this.myName, this.myGender, this.adminStr, this.stealthmode, this.myAge, this.myCountry, this.isVip, this.myIP, this.vipStr, this.keyRoomStr);
            return;
        }// end function

        private function connectCountry() : void
        {
            this.nc.connect(this.fms_country);
            this.tracker.trackPageview("Connecting_Country_RTMP");
            return;
        }// end function

        function sendKA(event:TimerEvent) : void
        {
            this.nc.call("keepAlive", null);
            this.tracker.trackPageview("Sending KeepAlive Call");
            return;
        }// end function

        private function netStatusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    if (this.countryConn == true)
                    {
                        return;
                    }
                    this.manageSO();
                    if (this.firstLogon == true)
                    {
                        this.Application.rooms_lb.addEventListener(Event.CHANGE, this.changeRoom);
                        this.Application.rooms_lb.addItem({label:"Cargando Salas..."});
                        this.EncryptStringRijndael55(this.myIP);
                        this.tracker.trackPageview("WELCOME TO CHATVIDEO!");
                        this.firstLogon = false;
                        if (this.isVip == true)
                        {
                            stage.scaleMode = StageScaleMode.SHOW_ALL;
                        }
                    }
                    this.isConnected = true;
                    this.Application.people_lb.removeAll();
                    this.Application.people_lb.addItem({label:"Cargando..."});
                    this.login_mc.conn_anim.visible = false;
                    this.login_mc.server_msg.text = "";
                    this.login_mc.visible = false;
                    this.Application.visible = true;
                    this.changingRoom = false;
                    this.manageStreams();
                    if (this.sending_video)
                    {
                        this.startCam();
                    }
                    return;
                }
                case "NetConnection.Connect.Failed":
                {
                    this.showAlerts("<br><br>Conexion fallida con el servidor <br>Intenta nuevamente!<br><br>");
                    this.login_mc.conn_anim.visible = false;
                    this.login_mc.server_msg.text = "";
                    this.login_mc.login_btn.enabled = true;
                    this.isConnected = false;
                    this.countryConn = true;
                    this.tracker.trackPageview("NetConnection.Connect.Failed");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    this.Application.modTools.visible = false;
                    this.updateTimer67.stop();
                    this.killTimer.stop();
                    if (this.rejected)
                    {
                        return;
                    }
                    if (this.changingRoom)
                    {
                        break;
                    }
                    else
                    {
                        this.showAlerts("<br><br>SE HA PERDIDO CONEXIÓN CON EL SERVIDOR<br><br>");
                        this.countryConn = true;
                        this.Application.visible = false;
                        this.tracker.trackPageview("NetConnection.Connect.Closed");
                        this.isConnected = false;
                        return;
                    }
                }
                case "NetConnection.Connect.Rejected":
                {
                    this.rejected = true;
                    this.isConnected = false;
                    this.countryConn = true;
                    if (event.info.application.msg == "Todos los espacios libres estan ocupados, Registrate para acceso inmediato!")
                    {
                        this.tracker.trackPageview("Lobby Full, Try Again");
                        this.nc.close();
                        this.roomID = this.roomID2;
                        this.login_mc.login_btn.enabled = true;
                        this.login_mc.conn_anim.visible = false;
                        this.login_mc.visible = true;
                        this.Application.visible = false;
                        this.login_mc.server_msg.text = event.info.application.msg;
                        if (this.firstLobby == false)
                        {
                            this.roomID = this.roomID3;
                            this.firstLobby = true;
                        }
                        this.firstLobby = false;
                        return;
                    }
                    this.showAlerts("<br><br>CONEXION RECHAZADA POR EL SERVIDOR<br><br>" + event.info.application.msg + "<br>");
                    this.login_mc.login_btn.enabled = true;
                    this.login_mc.conn_anim.visible = false;
                    this.login_mc.visible = true;
                    this.Application.visible = false;
                    this.tracker.trackPageview("Conn Rejected, Reason: " + event.info.application.msg);
                    this.login_mc.server_msg.text = event.info.application.msg;
                    this.nc.close();
                    return;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function showAlerts(param1) : void
        {
            this.myAlert3 = new AlertWindow();
            var _loc_2:* = {colorA:12177384, colorB:15265782, thickness:1, strokeColor:16777215, blurColor:0, blurAlpha:1, curve:4};
            var _loc_3:* = {size:15, color:0, font:"_sans"};
            var _loc_4:* = {size:12, color:600953, font:"_sans"};
            var _loc_5:* = {colorA:15066597, colorB:16777215, thickness:0.5, strokeColor:8947848};
            var _loc_6:* = {colorA:11852007, colorB:16777215, thickness:0.5, strokeColor:1284567};
            var _loc_7:* = {color:14211288};
            var _loc_8:* = {mainBg:_loc_2, message:_loc_3, button:_loc_4, buttonUp:_loc_5, buttonOver:_loc_6, freez:_loc_7};
            this.myAlert3.style = _loc_8;
            this.myAlert3.id = "systemInfo";
            this.myAlert3.message = param1;
            this.myAlert3.confirmBtn = "OK";
            this.addChild(this.myAlert3);
            this.myAlert3.show();
            this.tracker.trackPageview("Alert: " + param1);
            return;
        }// end function

        public function showAlerts2(param1:String, param2:String) : void
        {
            this.inviteSender = param1;
            this.inviteSenderIP = param2;
            if (this.alertOn)
            {
                this.removeChild(this.myAlert);
                this.alertOn = false;
            }
            this.myAlert = new AlertWindow();
            var _loc_3:* = {colorA:12177384, colorB:15265782, thickness:1, strokeColor:16777215, blurColor:0, blurAlpha:1, curve:4};
            var _loc_4:* = {size:15, color:0, font:"_sans"};
            var _loc_5:* = {size:12, color:600953, font:"_sans"};
            var _loc_6:* = {colorA:15066597, colorB:16777215, thickness:0.5, strokeColor:8947848};
            var _loc_7:* = {colorA:11852007, colorB:16777215, thickness:0.5, strokeColor:1284567};
            var _loc_8:* = {color:14211288};
            var _loc_9:* = {mainBg:_loc_3, message:_loc_4, button:_loc_5, buttonUp:_loc_6, buttonOver:_loc_7, freez:_loc_8};
            this.myAlert.style = _loc_9;
            this.myAlert.id = "btn1";
            this.myAlert.message = param1 + "<br><br>Te ha invitado a una sala privada...";
            this.myAlert.confirmBtn = "ACEPTAR";
            this.myAlert.rejectBtn = "RECHAZAR";
            this.myAlert.addEventListener(AlertEvents.CONFIRM, this.inviteOnAccept);
            this.myAlert.addEventListener(AlertEvents.REJECT, this.inviteOnReject);
            this.addChild(this.myAlert);
            this.myAlert.show();
            this.tracker.trackPageview("Invitation Received!");
            this.alertOn = true;
            return;
        }// end function

        public function showRegAlert(param1:String) : void
        {
            this.myAlert2 = new AlertWindow();
            var _loc_2:* = {colorA:12177384, colorB:15265782, thickness:1, strokeColor:16777215, blurColor:0, blurAlpha:1, curve:4};
            var _loc_3:* = {size:15, color:0, font:"_sans"};
            var _loc_4:* = {size:12, color:600953, font:"_sans"};
            var _loc_5:* = {colorA:15066597, colorB:16777215, thickness:0.5, strokeColor:8947848};
            var _loc_6:* = {colorA:11852007, colorB:16777215, thickness:0.5, strokeColor:1284567};
            var _loc_7:* = {color:14211288};
            var _loc_8:* = {mainBg:_loc_2, message:_loc_3, button:_loc_4, buttonUp:_loc_5, buttonOver:_loc_6, freez:_loc_7};
            this.myAlert2.style = _loc_8;
            this.myAlert2.id = "RegAlert";
            this.myAlert2.message = param1;
            this.myAlert2.confirmBtn = "Registrarme";
            this.myAlert2.rejectBtn = "Cerrar";
            this.myAlert2.addEventListener(AlertEvents.CONFIRM, this.regAlertResponse);
            this.addChild(this.myAlert2);
            this.myAlert2.show();
            this.tracker.trackPageview("Show Reg Alert:" + param1);
            return;
        }// end function

        function regAlertResponse(event:Event) : void
        {
            var _loc_2:* = new URLRequest("http://www.chatvideo.es/reg.html");
            navigateToURL(_loc_2, "_blank");
            this.tracker.trackPageview("REGISTER_URL_CLICKED");
            return;
        }// end function

        function inviteOnAccept(event:Event) : void
        {
            this.tracker.trackPageview("PRIVATE_INVIT_ACCEPTED");
            this.inviteAccept(this.inviteSender);
            return;
        }// end function

        function inviteOnReject(event:Event) : void
        {
            this.nc.call("PVrejected", null, this.inviteSender, this.myName);
            this.tracker.trackPageview("PRIVATE_INVIT_REJECTED");
            return;
        }// end function

        public function rejectedPV(param1:String) : void
        {
            this.tracker.trackPageview("PV INVIT REJECTED BY: " + param1);
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + param1 + " no aceptó tu invitación.");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function acceptedPV(param1:String) : void
        {
            var goPV:Function;
            var pvRoomID:* = param1;
            goPV = function () : void
            {
                Application.History.htmlText = "";
                closecam1();
                closecam2();
                closecam3();
                tracker.trackPageview("PV INVIT ACCEPTED, GOING PV");
                connectApp();
                return;
            }// end function
            ;
            var pvTimer:* = new Timer(1000, 1);
            pvTimer.addEventListener(TimerEvent.TIMER, goPV);
            this.roomID = pvRoomID;
            this.changingRoom = true;
            this.Application.people_lb.removeAll();
            this.Application.people_lb.addItem({label:"Cargando..."});
            pvTimer.start();
            this.doDisconnect();
            return;
        }// end function

        public function imHere(param1)
        {
            return true;
        }// end function

        public function serverMsg9(param1:String, param2:String) : void
        {
            if (this.Application.optionsMC.avisos.selected == false)
            {
                return;
            }
            var _loc_3:* = "<font face=\'Tahoma\' size=\'12\' color=\"" + param2 + "\">" + param1 + "</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function serverMsg(param1:String, param2:String) : void
        {
            this.tracker.trackPageview("From Server: " + param1);
            var _loc_3:* = "<font face=\'Arial\' size=\'12\' color=\"" + param2 + "\">" + param1 + "</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_3;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function receiveMessage(param1:String, param2:String, param3:String) : void
        {
            if (this.Application.optionsMC.pvCheck.selected == false)
            {
                this.nc.call("IgnoUser2", null, param2, this.myName);
                this.tracker.trackPageview("RECEIVE_PV_OFF");
                return;
            }
            var _loc_4:* = 0;
            while (_loc_4 < this.ignoredPPL.length)
            {
                
                if (this.ignoredPPL[_loc_4] == param3)
                {
                    this.tracker.trackPageview("USER_IGNORED_DON\'T_SHOW_PV_MSG");
                    return;
                }
                _loc_4 = _loc_4 + 1;
            }
            if (this.bellSound == true)
            {
                this.tracker.trackPageview("PLAY_PV_SOUND");
                this.myBell.play();
            }
            this.tracker.trackPageview("PV MSG RECEIVED!");
            this.Application.History.htmlText = this.Application.History.htmlText + param1;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function ignoredMe2(param1:String) : void
        {
            var _loc_2:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'>* " + param1 + " no acepta mensajes privados</font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_2;
            this.tracker.trackPageview("NOT ACCEPTING PM: " + param1);
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function receiveAdminMessage(param1:String) : void
        {
            this.Application.History.htmlText = this.Application.History.htmlText + param1;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function vipME(param1:String) : void
        {
            return;
        }// end function

        public function receiveHistory(param1:String) : void
        {
            this.Application.History.htmlText = "";
            this.tracker.trackPageview("Chat_Cleared");
            return;
        }// end function

        public function receiveTimeOut(param1:String) : void
        {
            this.tracker.trackPageview("MASS TIMEOUT FROM ADMIN");
            return;
        }// end function

        public function setCountry(param1:String) : void
        {
            this.myIP = param1;
            this.sendRealIP(this.myIP);
            this.tracker.trackPageview("setCountry();");
            return;
        }// end function

        public function setRoomNameAndID(param1:String, param2:String) : void
        {
            this.tracker.trackPageview("Room Name: " + param1);
            this.currentRoomID = param2;
            this.roomTitle = param1;
            this.Application.chat_title.text = "Chat en " + param1;
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' color=\'#000000\' size=\'12\'>Bienvenido a la sala <font color=\'#FF0000\'>" + param1 + "</font>");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function onRoomownerauth() : void
        {
            var kickUser:Function;
            kickUser = function (event:MouseEvent) : void
            {
                var _loc_2:* = theWho;
                if (_loc_2 != undefined)
                {
                    nc.call("kickUser", null, _loc_2, myName);
                }
                return;
            }// end function
            ;
            this.tracker.trackPageview("MY_ROOM_SHOW_MODTOOLS!");
            this.Application.modTools.visible = true;
            if (this.sendRoomKey != "")
            {
                this.nc.call("setRoomKey", null, this.sendRoomKey, this.myName);
            }
            this.nc.call("runTimer", null);
            this.killTimer.start();
            if (this.firstOwnerAuth)
            {
                this.Application.modTools.kick_bt.addEventListener(MouseEvent.CLICK, kickUser);
                this.Application.modTools.ban_bt.addEventListener(MouseEvent.CLICK, this.iBanUser);
                this.firstOwnerAuth = false;
            }
            return;
        }// end function

        function iBanUser(event:MouseEvent) : void
        {
            var _loc_2:* = this.theWho;
            if (_loc_2 != undefined)
            {
                this.nc.call("BanUser", null, _loc_2, this.myName);
            }
            return;
        }// end function

        public function inviteME(param1:String, param2:String) : void
        {
            this.tracker.trackPageview("PV INVIT");
            var _loc_3:* = 0;
            while (_loc_3 < this.ignoredPPL.length)
            {
                
                if (this.ignoredPPL[_loc_3] == param2)
                {
                    this.tracker.trackPageview("Ignored user, don\'t show his invitation");
                    return;
                }
                _loc_3 = _loc_3 + 1;
            }
            var _loc_4:* = param1 + " te ha invitado a una sala privada";
            if (this.Application.optionsMC.invCheck.selected != true)
            {
                return;
            }
            this.showAlerts2(param1, param2);
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        function ignoreLink(event:TextEvent) : void
        {
            this.ignoreUser(event.text);
            this.tracker.trackPageview("IGNORE CLICKED");
            return;
        }// end function

        public function ignoreUser(param1) : void
        {
            var _loc_2:* = param1;
            var _loc_3:* = _loc_2.split(",");
            var _loc_4:* = 0;
            while (_loc_4 < this.ignoredPPL.length)
            {
                
                if (this.ignoredPPL[_loc_4] == _loc_3[1])
                {
                    this.ignoTip(_loc_3[0] + " ya esta siendo ignorad@");
                    this.tracker.trackPageview("ALREADY_IGNORING_THAT_PERSON");
                    return;
                }
                _loc_4 = _loc_4 + 1;
            }
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font color=\'#FF0000\' face=\'Arial\' size=\'12\'>* " + _loc_3[0] + " ha sido ignorad@");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            var _loc_5:* = _loc_3[0];
            var _loc_6:* = this.myName;
            this.ignoredPPL.push(_loc_3[1]);
            this.nc.call("IgnoUser", null, _loc_5, _loc_6);
            return;
        }// end function

        public function ignoredMe(param1:String) : void
        {
            this.tracker.trackPageview("IGNORE_RECEIVED");
            if (param1 == this.Application.cam1.cam1_wtxt.text)
            {
                this.closecam1();
            }
            if (param1 == this.Application.cam2.cam1_wtxt.text)
            {
                this.closecam2();
            }
            if (param1 == this.Application.cam3.cam1_wtxt.text)
            {
                this.closecam3();
            }
            var _loc_2:* = "* " + param1 + " te ha ignorado";
            this.Application.History.htmlText = this.Application.History.htmlText + ("<font face=\'Arial\' size=\'12\' color=\'#FF0000\'>" + _loc_2 + "</font>");
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function Banned(param1:String) : void
        {
            this.rejected = true;
            this.Application.visible = false;
            this.nc.close();
            this.doDisconnect();
            this.doDisconnect();
            this.doDisconnect();
            this.showAlerts("<br><br>Has sido Bloqueado por " + param1 + "<br><br>");
            this.tracker.trackPageview("I_WAS_BANNED_BY_" + param1);
            return;
        }// end function

        public function kickMe(param1:String) : void
        {
            this.rejected = true;
            this.Application.visible = false;
            this.nc.close();
            this.doDisconnect();
            this.doDisconnect();
            this.doDisconnect();
            this.showAlerts("<br><br>Has sido Expulsad@ por " + param1 + "<br><br>");
            this.tracker.trackPageview("I_WAS_KICKED_BY_" + param1);
            return;
        }// end function

        public function Banned2(param1:String) : void
        {
            return;
        }// end function

        public function floodBan(param1:String) : void
        {
            if (this.stealthmode == false)
            {
                this.rejected = true;
                this.Application.visible = false;
                this.doDisconnect();
                this.showAlerts("<br><br>Has sido Desconectad@ por hacer flood<br><br>");
                this.tracker.trackPageview("I_WAS_KICKED_BY_FLOODING");
            }
            return;
        }// end function

        public function flagMe(param1:String) : void
        {
            this.tracker.trackPageview("RED_FLAG_RECEIVED,_BUT_I\'M_VIP,_DO_NOTHING...");
            return;
        }// end function

        public function setVotesNumber(param1:String) : void
        {
            this.Application.myCamMC.likesText.text = param1;
            this.local_so.data.myVotes = param1;
            this.local_so.flush();
            return;
        }// end function

        public function roomDeleted() : void
        {
            this.tracker.trackPageview("room_Deleted,_closing_connection");
            this.showAlerts("<br><br>La sala ha finalizado sesión<br>Has ingresado a Lobby<br><br>");
            this.roomID = this.lobbyID;
            if (this.isVip && this.sending_video)
            {
                this.stopCam();
            }
            this.changingRoom = true;
            this.Application.History.htmlText = "";
            this.nc.close();
            this.doDisconnect();
            this.connectApp();
            return;
        }// end function

        public function close() : void
        {
            return;
        }// end function

        public function globalMsg(param1:String) : void
        {
            var _loc_2:* = "<font color=\'#FF0000\' face=\'Tahoma\' size=\'13\'><br><br><br><b>" + param1 + "</b><br><br><br></font>";
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_2;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function onReceiveMsgMobile(param1:String, param2:String, param3:String, param4:String, param5:String) : void
        {
            return;
        }// end function

        public function onReceiveMsg(param1:String, param2:String, param3:String, param4:String, param5:String) : void
        {
            var _loc_6:* = null;
            if (param2 != param5)
            {
                return;
            }
            var _loc_7:* = 0;
            while (_loc_7 < this.ignoredPPL.length)
            {
                
                if (this.ignoredPPL[_loc_7] == param4)
                {
                    this.tracker.trackPageview("IGNORED_USER_DON\'T_DISPLAY_MESSAGE");
                    return;
                }
                _loc_7 = _loc_7 + 1;
            }
            if (this.Application.History.length > 21400)
            {
                this.Application.History.htmlText = "";
            }
            if (param2 == this.myName)
            {
                _loc_6 = "<b><font face=\'Tahoma\' size=\'15\' color=\'#FF7004\'> " + param2 + ": </font></b>" + param1;
                this.Application.History.htmlText = this.Application.History.htmlText + _loc_6;
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            _loc_6 = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><b><font face=\'Tahoma\' size=\'14\' color=\'#FF7004\'> " + param2 + ": </font></b>" + param1;
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_6;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function onReceiveMsgUser(param1:String, param2:String, param3:String, param4:String, param5:String) : void
        {
            var _loc_6:* = null;
            if (param2 != param5)
            {
                return;
            }
            var _loc_7:* = 0;
            while (_loc_7 < this.ignoredPPL.length)
            {
                
                if (this.ignoredPPL[_loc_7] == param4)
                {
                    this.tracker.trackPageview("IGNORED_USER_DON\'T_DISPLAY_MESSAGE");
                    return;
                }
                _loc_7 = _loc_7 + 1;
            }
            param1 = param1.toLowerCase();
            if (this.Application.History.length > 21400)
            {
                this.Application.History.htmlText = "";
            }
            if (param2 == this.myName)
            {
                _loc_6 = "<b><font face=\'Tahoma\' size=\'15\' color=\'#000000\'> " + param2 + ": </font></b>" + param1;
                this.Application.History.htmlText = this.Application.History.htmlText + _loc_6;
                this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
                return;
            }
            _loc_6 = "<font color=\'#0000FF\' face=\'Tahoma\' size=\'13\'><a href=\"event:" + param2 + "," + param4 + "\"><b>[ignorar]</b></a></font><font face=\'Tahoma\' size=\'14\' color=\'#002A45\'><b> " + param2 + ": </b></font><font size=\'13\'>" + param1;
            this.Application.History.htmlText = this.Application.History.htmlText + _loc_6;
            this.Application.History.verticalScrollPosition = this.Application.History.maxVerticalScrollPosition;
            return;
        }// end function

        public function determineIcon(param1:Object) : String
        {
            if (param1.iswatching == this.myName)
            {
                if (param1.gender == "male" && param1.streaming == "online")
                {
                    return "male_watches";
                }
                if (param1.gender == "male" && param1.streaming == "idle")
                {
                    return "male_cam_watches";
                }
                if (param1.gender == "couple" && param1.streaming == "online")
                {
                    return "couple_watches";
                }
                if (param1.gender == "couple" && param1.streaming == "idle")
                {
                    return "couple_cam_watches";
                }
                if (param1.gender == "female" && param1.streaming == "online")
                {
                    return "female_watches";
                }
                if (param1.gender == "female" && param1.streaming == "idle")
                {
                    return "female_cam_watches";
                }
            }
            if (param1.iswatching != this.myName)
            {
                if (param1.gender == "male" && param1.streaming == "online")
                {
                    return "male";
                }
                if (param1.gender == "male" && param1.streaming == "idle")
                {
                    return "male_cam";
                }
                if (param1.gender == "couple" && param1.streaming == "online")
                {
                    return "couple";
                }
                if (param1.gender == "couple" && param1.streaming == "idle")
                {
                    return "couple_cam";
                }
                if (param1.gender == "female" && param1.streaming == "online")
                {
                    return "female";
                }
                if (param1.gender == "female" && param1.streaming == "idle")
                {
                    return "female_cam";
                }
            }
            return "";
        }// end function

        function frame1()
        {
            stop();
            this.addEventListener(Event.ENTER_FRAME, this.loading);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            return;
        }// end function

        function frame2()
        {
            stop();
            this.myBell = new Sound();
            this.xmlLoader = new URLLoader();
            this.xmlLoader.addEventListener(Event.COMPLETE, this.loadXML);
            this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderMissing);
            this.xmlData = new XML();
            this.xmlFile = "vipC1.xml" + "?" + Math.random();
            this.xmlLoader.load(new URLRequest(this.xmlFile));
            if (this.isVip == true)
            {
                this.request = new URLRequest("user_as3.php");
                this.request.method = URLRequestMethod.GET;
                this.VIPloader = new URLLoader();
                this.VIPloader.dataFormat = URLLoaderDataFormat.VARIABLES;
                this.VIPloader.addEventListener(Event.COMPLETE, this.completeHandler);
                this.VIPloader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderMissing2);
                this.VIPloader.load(this.request);
            }
            this.url = "http://www.chatvideo.es/local_as3.php";
            this.bf = new BlurFilter(5, 5, 5);
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
            this.Application.people_lb.setRendererStyle("textFormat", this.fmt);
            this.Application.rooms_lb.setRendererStyle("textFormat", this.fmtRoomList);
            this.Application.people_lb.rowHeight = 28;
            this.Application.rooms_lb.rowHeight = 25;
            this.Application.cam1.likeCam.setStyle("icon", like_graphic);
            this.Application.cam2.likeCam.setStyle("icon", like_graphic);
            this.Application.cam3.likeCam.setStyle("icon", like_graphic);
            this.Application.cam1.likeCam.setStyle("textPadding", 0);
            this.Application.cam2.likeCam.setStyle("textPadding", 0);
            this.Application.cam3.likeCam.setStyle("textPadding", 0);
            this.Application.option_bt.setStyle("icon", settings_graphic);
            this.Application.cam1.flag_bt.setStyle("icon", warning_graphic);
            this.Application.cam1.invite_bt.setStyle("icon", corazon_graphic);
            this.Application.cam2.flag_bt.setStyle("icon", warning_graphic);
            this.Application.cam2.invite_bt.setStyle("icon", corazon_graphic);
            this.Application.cam3.flag_bt.setStyle("icon", warning_graphic);
            this.Application.cam3.invite_bt.setStyle("icon", corazon_graphic);
            this.Application.mensPv.invite_bt.setStyle("icon", corazon_graphic);
            this.Application.optionsMC.cam_conf_bt.setStyle("icon", webcam_graphic);
            this.Application.optionsMC.close_opt.setStyle("icon", check_graphic);
            this.Application.create_pb.setStyle("icon", add_graphic);
            this.Application.logout_bt.setStyle("icon", logout_graphic);
            this.likesCam1Format = new TextFormat();
            this.likesCam1Format.font = "Tahoma";
            this.likesCam1Format.color = 0;
            this.likesCam1Format.size = "12";
            this.likesCam1Format.bold = true;
            this.Application.cam1.likeCam.setStyle("textFormat", this.likesCam1Format);
            this.Application.cam2.likeCam.setStyle("textFormat", this.likesCam1Format);
            this.Application.cam3.likeCam.setStyle("textFormat", this.likesCam1Format);
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
            this.newRmc.newRN.setStyle("textFormat", this.formatRMsg);
            this.newRmc.newRD.setStyle("textFormat", this.formatRMsg);
            this.newRmc.newRP.setStyle("textFormat", this.formatRMsg);
            this.newRmc.newRV.setStyle("textFormat", this.formatRMsg);
            this.newRmc.newR_ok_pb.setStyle("textFormat", this.formatRMsg2);
            this.newRmc.newRcancel_pb.setStyle("textFormat", this.formatRMsg2);
            this.enterRoomMC.claveSala.setStyle("textFormat", this.formatRMsg);
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
            this.Application.activateCam.setStyle("textFormat", this.startCamFormat);
            this.Application.activateMic.setStyle("textFormat", this.startCamFormat);
            this.optionsFormat = new TextFormat();
            this.optionsFormat.font = "Tahoma";
            this.optionsFormat.color = 3355443;
            this.optionsFormat.size = "12";
            this.optionsFormat.bold = true;
            this.Application.optionsMC.vipCheck.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.userCheck.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.pvCheck.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.invCheck.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.avisos.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.bellCheck.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.close_opt.setStyle("textFormat", this.optionsFormat);
            this.Application.optionsMC.cam_conf_bt.setStyle("textFormat", this.optionsFormat);
            this.Application.bigRegister.bigLink.setStyle("textFormat", this.startCamFormat);
            this.Application.bigRegister.closeLink.setStyle("textFormat", this.startCamFormat);
            this.Application.mensPv.pv_msg.setStyle("textFormat", this.formatPVMsg);
            this.Application.mensPv.pv_msg.condenseWhite = true;
            this.Application.msg.setStyle("textFormat", this.formatMsg);
            this.login_mc.login_btn.setStyle("textFormat", this.loginFormat2);
            this.login_mc.login_name.setStyle("textFormat", this.loginFormat);
            this.login_mc.age_box.textField.setStyle("textFormat", this.loginFormat2);
            this.login_mc.age_box.dropdown.setRendererStyle("textFormat", this.loginFormat2);
            this.Application.msg.condenseWhite = true;
            this.login_mc.login_name.condenseWhite = true;
            this.Application.b_bt.addEventListener(MouseEvent.CLICK, this.doBold);
            this.Application.i_bt.addEventListener(MouseEvent.CLICK, this.doItalic);
            this.Application.u_bt.addEventListener(MouseEvent.CLICK, this.doUnderline);
            this.Application.colorPick.addEventListener(ColorPickerEvent.CHANGE, this.changeHandler);
            this.Application.fontSel.addEventListener(Event.CHANGE, this.changeFont);
            this.Application.fontSize_bt.addEventListener(MouseEvent.CLICK, this.changeFontSize);
            this.Application.fontType_bt.addEventListener(MouseEvent.CLICK, this.showFonts);
            this.textFilter = new GlowFilter();
            var _loc_1:* = 3;
            this.textFilter.blurY = 3;
            this.textFilter.blurX = _loc_1;
            this.textFilter.strength = 2;
            this.textFilter.color = 3355443;
            this.Application.cam1.cam1_txt.filters = [this.textFilter];
            this.Application.cam2.camname.filters = [this.textFilter];
            this.Application.cam3.camname.filters = [this.textFilter];
            this.Application.myCamMC.myName.filters = [this.textFilter];
            this.Application.myCamMC.likesText.filters = [this.textFilter];
            this.Application.adminTools.visible = false;
            this.Application.fontSel.visible = false;
            this.Application.cam1.close_bt.addEventListener(MouseEvent.CLICK, this.cierraCam);
            this.Application.sort_bt.addEventListener(MouseEvent.CLICK, this.sortPeople);
            this.Application.bigRegister.bigLink.addEventListener(MouseEvent.CLICK, this.regCLickURL);
            this.Application.bigRegister.closeLink.addEventListener(MouseEvent.CLICK, this.closeCLick);
            this.Application.fullScreen_bt.addEventListener(MouseEvent.CLICK, this._handleClick);
            this.fontSelFormat = new TextFormat();
            this.fontSelFormat.font = "Tahoma";
            this.fontSelFormat.color = 4299399;
            this.fontSelFormat.size = "14";
            this.fontSelFormat.bold = true;
            this.Application.fontSel.setRendererStyle("textFormat", this.fontSelFormat);
            this.Application.fontSel.rowHeight = 25;
            this.Application.fontSel.addItem({label:"Arial"});
            this.Application.fontSel.addItem({label:"Comic Sans MS"});
            this.Application.fontSel.addItem({label:"Courier New"});
            this.Application.fontSel.addItem({label:"Calibri"});
            this.Application.fontSel.addItem({label:"Consolas"});
            this.Application.fontSel.addItem({label:"Courier New"});
            this.Application.fontSel.addItem({label:"Franklin Gothic Medium"});
            this.Application.fontSel.addItem({label:"Georgia"});
            this.Application.fontSel.addItem({label:"Kartika"});
            this.Application.fontSel.addItem({label:"MS Serif"});
            this.Application.fontSel.addItem({label:"MV Boli"});
            this.Application.fontSel.addItem({label:"Palatino Linotype, Book Antiqua"});
            this.Application.fontSel.addItem({label:"Segoe Print"});
            this.Application.fontSel.addItem({label:"Segoe Script"});
            this.Application.fontSel.addItem({label:"Segoe UI"});
            this.Application.fontSel.addItem({label:"Tahoma"});
            this.Application.fontSel.addItem({label:"Trebuchet MS"});
            this.Application.fontSel.addItem({label:"Verdana"});
            this.Application.fontSel.addItem({label:"Westminster"});
            this.Application.option_bt.addEventListener(MouseEvent.CLICK, this.showOptionsPanel);
            this.Application.optionsMC.close_opt.addEventListener(MouseEvent.CLICK, this.closeOptionsPanel);
            this.login_mc.server_msg.visible = false;
            this.killTimer = new Timer(7000, 0);
            this.killTimer.addEventListener(TimerEvent.TIMER, this.sendKA);
            this.login_mc.login_btn.addEventListener(MouseEvent.CLICK, this.loginUser);
            this.genderGroup = new RadioButtonGroup("genderRadio");
            this.login_mc.maleRadio.addEventListener(MouseEvent.CLICK, this.announceCurrentGroup);
            this.login_mc.femaleRadio.addEventListener(MouseEvent.CLICK, this.announceCurrentGroup);
            this.login_mc.coupleRadio.addEventListener(MouseEvent.CLICK, this.announceCurrentGroup);
            this.reportedPPL = new Array();
            this.rijndael_key5 = "79566214843925";
            this.Application.cam1.flag_bt.addEventListener(MouseEvent.CLICK, this.reportUser);
            this.Application.cam2.flag_bt.addEventListener(MouseEvent.CLICK, this.reportUser2);
            this.Application.cam3.flag_bt.addEventListener(MouseEvent.CLICK, this.reportUser3);
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
            this.Application.cam1.addEventListener(MouseEvent.MOUSE_OVER, this.HandleMouseOver);
            this.Application.cam1.addEventListener(MouseEvent.MOUSE_OUT, this.HandleMouseOut);
            this.Application.cam1.underbutt.visible = false;
            this.Application.cam2.underbutt.visible = false;
            this.Application.cam3.underbutt.visible = false;
            this.Application.cam2.addEventListener(MouseEvent.MOUSE_OVER, this.HandleMouseOver2);
            this.Application.cam2.addEventListener(MouseEvent.MOUSE_OUT, this.HandleMouseOut2);
            this.Application.cam3.addEventListener(MouseEvent.MOUSE_OVER, this.HandleMouseOver3);
            this.Application.cam3.addEventListener(MouseEvent.MOUSE_OUT, this.HandleMouseOut3);
            this.Application.cam1.volMC.volSlide.addEventListener(SliderEvent.CHANGE, this.volChange);
            this.Application.cam2.volMC.volSlide.addEventListener(SliderEvent.CHANGE, this.volChange2);
            this.Application.cam3.volMC.volSlide.addEventListener(SliderEvent.CHANGE, this.volChange3);
            this.LCTest();
            this.curSelectionUser = null;
            this.globalMessage = "";
            this.doSyncOnce = true;
            this.Application.History.addEventListener(TextEvent.LINK, this.ignoreLink);
            this.updateTimer = new Timer(4000, 1);
            this.updateTimer.addEventListener(TimerEvent.TIMER, this.onTimeUp);
            this.updateTimer67 = new Timer(3000, 0);
            this.updateTimer67.addEventListener(TimerEvent.TIMER, this.onTimeUp888);
            this.Application.mensPv.visible = false;
            this.usersDP = new DataProvider();
            this.Application.people_lb.dataProvider = this.usersDP;
            this.Application.people_lb.iconFunction = this.determineIcon;
            this.Application.people_lb.addEventListener(Event.CHANGE, this.selectedUser);
            this.roomsDP = new DataProvider();
            this.Application.rooms_lb.dataProvider = this.roomsDP;
            this.Application.mensPv.sendPV_but.addEventListener(MouseEvent.CLICK, this.doSendPV);
            this.Application.msg.addEventListener(FocusEvent.FOCUS_IN, this.onTextSelect);
            this.Application.mensPv.pv_msg.addEventListener(FocusEvent.FOCUS_IN, this.onTextSelect);
            this.Application.send_pb.addEventListener(MouseEvent.CLICK, this.doSend);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.Application.mensPv.closePV_but.addEventListener(MouseEvent.CLICK, this.closePV);
            this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OVER, this.showCreateTip);
            this.Application.create_pb.addEventListener(MouseEvent.MOUSE_OUT, this.hideCreateTip);
            this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showInviteTip);
            this.Application.cam1.invite_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideInviteTip);
            this.Application.cam2.invite_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showInviteTip2);
            this.Application.cam2.invite_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideInviteTip);
            this.Application.cam3.invite_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showInviteTip3);
            this.Application.cam3.invite_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideInviteTip);
            this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showFlagTip);
            this.Application.cam1.flag_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideFlagTip);
            this.Application.cam2.flag_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showFlagTip);
            this.Application.cam2.flag_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideFlagTip);
            this.Application.cam3.flag_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showFlagTip);
            this.Application.cam3.flag_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideFlagTip);
            this.Application.people_lb.addEventListener(ListEvent.ITEM_ROLL_OVER, this.showUserInfo);
            this.Application.people_lb.addEventListener(ListEvent.ITEM_ROLL_OUT, this.hideUserInfo);
            this.Application.rooms_lb.addEventListener(ListEvent.ITEM_ROLL_OVER, this.showRoomInfo);
            this.Application.rooms_lb.addEventListener(ListEvent.ITEM_ROLL_OUT, this.hideUserInfo);
            this.Application.logout_bt.addEventListener(MouseEvent.MOUSE_OVER, this.showLogout);
            this.Application.logout_bt.addEventListener(MouseEvent.MOUSE_OUT, this.hideLogout);
            this.myTimer = new Timer(1000, 1);
            this.myTimer.addEventListener(TimerEvent.TIMER, this.hideIgnoTip);
            this.h264Config = new H264VideoStreamSettings();
            this.mic_on = false;
            this.camTimeUp = false;
            this.Application.myCamMC.visible = false;
            this.Application.optionsMC.visible = false;
            this.Application.optionsMC.bellOff.visible = false;
            this.Application.myCamMC.micVol.visible = false;
            this.Application.myCamMC.micIcon1.visible = false;
            this.Application.myCamMC.micMeter.visible = false;
            this.Application.myCamMC.micVol.addEventListener(SliderEvent.CHANGE, this.setMicLevel);
            this.Application.activateCam.addEventListener(MouseEvent.CLICK, this.cameraHandler);
            this.Application.optionsMC.bellCheck.addEventListener(MouseEvent.CLICK, this.bellHandler);
            this.Application.optionsMC.vipCheck.addEventListener(MouseEvent.CLICK, this.vipCamHandler);
            this.Application.activateMic.addEventListener(MouseEvent.CLICK, this.micHandler);
            this.badCamsLoader.addEventListener(Event.COMPLETE, this.onBadCamsLoaded);
            this.badCamsLoader.addEventListener(IOErrorEvent.IO_ERROR, this.badCamsError);
            this.badCamsLoader.load(new URLRequest("badCams.txt" + "?" + Math.random()));
            this.fakeTimer = new Timer(4000, 0);
            this.fakeTimer.addEventListener(TimerEvent.TIMER, this.fakeTick);
            this.Application.optionsMC.cam_conf_bt.addEventListener(MouseEvent.CLICK, this.showCamConf);
            this.Application.logout_bt.addEventListener(MouseEvent.CLICK, this.doLogout);
            this.rijndael_key = "pZwq50ol87t";
            this.myRoomPW = "";
            this.sendRoomKey = "";
            this.newRmc.newR_ok_pb.addEventListener(MouseEvent.CLICK, this.createNR);
            this.newRmc.newRcancel_pb.addEventListener(MouseEvent.CLICK, this.closeNR);
            this.newRmc.newRN.tabIndex = 1;
            this.newRmc.newRD.tabIndex = 2;
            this.newRmc.newRP.tabIndex = 3;
            this.newRmc.roomLimite.tabIndex = 4;
            this.newRmc.newRV.tabIndex = 5;
            this.newRmc.newR_ok_pb.tabIndex = 6;
            this.newRmc.newRcancel_pb.tabIndex = 7;
            this.Application.create_pb.addEventListener(MouseEvent.CLICK, this.createRoomHandler);
            this.enterRoomMC.entrar_bt.addEventListener(MouseEvent.CLICK, this.enterPWroom);
            this.enterRoomMC.cancelar_bt.addEventListener(MouseEvent.CLICK, this.enterPWroomClose);
            this.sendInvitation = true;
            this.Application.cam1.invite_bt.addEventListener(MouseEvent.CLICK, this.runInvite);
            this.Application.cam2.invite_bt.addEventListener(MouseEvent.CLICK, this.runInvite2);
            this.Application.cam3.invite_bt.addEventListener(MouseEvent.CLICK, this.runInvite3);
            this.Application.mensPv.invite_bt.addEventListener(MouseEvent.CLICK, this.runInvite4);
            this.invTimer = new Timer(10000, 1);
            this.invTimer.addEventListener(TimerEvent.TIMER, this.pvTimer);
            this.imgLoad = false;
            this.imgLoad2 = false;
            this.imgLoad3 = false;
            this.local_so = SharedObject.getLocal("VIP_V3");
            if (this.local_so.data.myName != undefined)
            {
                this.formatMsg.font = this.local_so.data.myFontType;
                this.formatMsg.color = this.local_so.data.myColor;
                this.formatMsg.bold = this.local_so.data.myFontBold;
                this.formatMsg.italic = this.local_so.data.myFontItalic;
                this.Application.msg.setStyle("textFormat", this.formatMsg);
                this.loginFormat.color = this.local_so.data.myColor;
                this.login_mc.login_name.setStyle("textFormat", this.loginFormat);
                this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
            }
            if (this.local_so.data.myVotes == undefined)
            {
                this.local_so.data.myVotes = 0;
                this.Application.myCamMC.likesText.text = this.local_so.data.myVotes;
            }
            this.Application.cam2.close_bt.addEventListener(MouseEvent.CLICK, this.closeCamClick);
            this.Application.cam3.close_bt.addEventListener(MouseEvent.CLICK, this.closeCamClick3);
            this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler4);
            this.Application.myCamMC.dragMe.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler4);
            this.Application.cam1.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser);
            this.Application.cam2.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser2);
            this.Application.cam3.likeCam.addEventListener(MouseEvent.CLICK, this.likeUser3);
            return;
        }// end function

        NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
    }
}
