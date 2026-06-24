package com.historian;

import java.text.ParseException;

import org.apache.commons.lang.StringUtils;
import org.apache.maven.model.Model;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AdapterController {
	private static String HISTORIAN_ADAPTER_IP = Config.getString(Config.KEY_HISTORIAN_ADAPTER_IP);
	private static int HISTORIAN_ADAPTER_PORT = Config.getInt(Config.KEY_HISTORIAN_ADAPTER_PORT);
	private static int HISTORIAN_ADAPTER_TIMEOUT = Config.getInt(Config.KEY_HISTORIAN_ADAPTER_TIMEOUT);

	@ResponseBody
	@RequestMapping(value = "/reqHistorian", produces = "application/json; charset=UTF-8")
	public String ReqPhd(Model model, @RequestBody String param) throws ParseException {
		String strIP = HISTORIAN_ADAPTER_IP;
		Integer strPort = HISTORIAN_ADAPTER_PORT;
		Integer strTimeout = HISTORIAN_ADAPTER_TIMEOUT;
		String strRet = "";

		try {
			JSONParser jsonParser = new JSONParser();
			Object obj = jsonParser.parse(param);
			JSONObject jobj = (JSONObject) obj;
			if (jobj.get("timeout") instanceof String) {
				String timeout = (String) jobj.get("timeout");
				if (StringUtils.isNotEmpty(timeout)) {
					try {
						strTimeout = Integer.parseInt(timeout);
					} catch (Exception e) {
					}
				}
			} else if (jobj.get("timeout") instanceof Long) {
				long timeout = (long) jobj.get("timeout");
				strTimeout = (int) timeout;
			} else {
				strTimeout = (int) jobj.get("timeout");
			}

			param = jobj.toJSONString();
		} catch (org.json.simple.parser.ParseException e) {
			System.out.println("hisAdapter ParseException : " + e.getMessage() + " / " + param);
		}

		DsanAdapter adpt = new DsanAdapter();
		boolean bRet = adpt.connect(strIP, strPort, strTimeout);

		if (bRet) {
			strRet = adpt.fetchValues(param);
		}
		adpt.disconnect();

		return strRet;
	}
}