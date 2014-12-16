using UnityEngine;
using System.Collections;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;


public class StageMachine : MonoBehaviour {

	private int recv;
	private byte[] data; 
	private Socket client ;
	private NetworkStream ns;
	private string debugString;
	private Thread oThread;
	private string stringData;
	private float lastConnectTime;
	
	void Start () {
		Screen.SetResolution (400, 400, false);
		data = new byte[1024];
		Init ();
	}

	void Update () {

		if( oThread != null){
			if (!oThread.IsAlive) {
				oThread = new Thread(new ThreadStart(this.SocketProcess));
				oThread.Start ();
			}
		}else{
			if(Time.time - lastConnectTime > 2){
				Init();
			}
		}
	}

	void OnGUI(){
		GUI.Box (new Rect (0, 0, Screen.width, Screen.height), 
		         "Client Console \n ----------------------------\n"+debugString);
	}

	void Init(){

		IPEndPoint ipep = new IPEndPoint(
			IPAddress.Parse("127.0.0.1"), 9050);
		
		client = new Socket(AddressFamily.InterNetwork,
		                           SocketType.Stream, ProtocolType.Tcp);
		lastConnectTime = Time.time;
		ConsoleWriteLine ("Connecting to Server...");
		try
		{
			client.Connect(ipep);
		} catch (SocketException e)
		{

			ConsoleWriteLine("Unable to connect to server");
			if(oThread != null){
				oThread = null;
			}
			return;
		}


		
		oThread = new Thread(new ThreadStart(this.SocketProcess));
		oThread.Start ();	
	}

	void ConsoleWriteLine(String msg){
		debugString = msg +"\n" + debugString;
	}

	void SocketProcess(){

		if (client != null) {
			if(client.Connected){
				byte[] buff = new byte[1];
				if( client.Receive( buff, SocketFlags.Peek ) == 0 )
				{	
					client.Close();
					client = null;
					ConsoleWriteLine("Disconnect to cilent\n");
					oThread = null;
				}else{
					data = new byte[1024];
					int recv = client.Receive(data);
					stringData = Encoding.ASCII.GetString(data, 0, recv);
					ConsoleWriteLine (stringData);
				}
			}else{
				client.Close();
				client = null;
				ConsoleWriteLine("Disconnect to cilent\n");
				oThread = null;
			}
		}

	}
}
