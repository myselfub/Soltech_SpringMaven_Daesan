package com.historian;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class DsanAdapter {
	Socket m_socket = null;

	public DsanAdapter() {
	}

	public boolean connect(String strAddr, int nPort, int nTimeout) {
		boolean bRet = true;

		if (m_socket == null) {
			try {
				m_socket = new Socket(strAddr, nPort);
				m_socket.setSoTimeout(nTimeout);
				bRet = true;
			} catch (IOException ex) {
				bRet = false;
				System.out.println("hisAdapter Connection fail: IOException : " + ex.getMessage());
			}
		}

		return bRet;
	}

	public boolean disconnect() {
		boolean bRet = false;

		if (m_socket != null) {
			try {
				m_socket.close();
				m_socket = null;
				bRet = true;
			} catch (IOException ex) {
				System.out.println("hisAdapter Disconnection fail: IOException");
			}
		}

		return bRet;
	}

	public String fetchValues(String strReq) {
		StringBuffer sb = new StringBuffer();
		OutputStream output = null;
		InputStream input = null;

		if (m_socket != null && m_socket.isConnected() == true) {
			try {
				output = m_socket.getOutputStream();

				byte[] req = strReq.getBytes();
				output.write(req);
				output.write('\n');

				input = m_socket.getInputStream();

				try {
					Thread.sleep(100);
				} catch (InterruptedException e1) {
					System.out.println(" hisAdapter : InterruptedException Occured2 (" + e1.getMessage());
				}

				while (true) {
					byte[] res = new byte[10 * 1024 * 1024];
					int nBytes = input.read(res);

					if (nBytes == -1) {
						break;
					}

					String strBuff = new String(res);
					strBuff = strBuff.substring(0, nBytes);
					sb.append(strBuff);
				}
			} catch (OutOfMemoryError e1) {
				System.out.println(" hisAdapter : OutOfMemoryError Exception (" + e1.getMessage() + ")"); // 버퍼 크기 감소 필요
			} catch (IOException e2) {
				System.out.println(" hisAdapter : I/O Exception (" + e2.getMessage() + ")");
			} finally {
				disconnect();

				try {
					input.close();
					output.close();
				} catch (IOException e) {
					System.out.println(" hisAdapter :  I/O Close Exception (" + e.getMessage() + ")");
				}
			}
		}

		JSONParser jp = new JSONParser();

		try {
			String strSb = sb.toString();
			if (strSb.contains("}]}")) {
				try {
					JSONObject jb = (JSONObject) jp.parse(strSb);
				} catch (ClassCastException e1) {
					System.out.println(" hisAdapter : Class Cast Exception (" + e1.getMessage() + ")");
				}
			}
		} catch (ParseException e) {
			System.out.println(" hisAdapter : Parse Exception Occured");
		}

		return sb.toString();
	}
}