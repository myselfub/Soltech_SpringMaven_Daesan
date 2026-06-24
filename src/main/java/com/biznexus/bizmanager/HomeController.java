package com.biznexus.bizmanager;

import org.springframework.stereotype.Controller;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	/*
	private static String reqTagIpAddr = Config.getString(Config.KEY_BIZNEXUS_REQ_TAG_IP);
	private static int reqTagIpPort = Config.getInt(Config.KEY_BIZNEXUS_REQ_TAG_PORT);
	private static String dllPath = Config.getString(Config.KEY_BIZNEXUS_DLL_PATH); 
	private static String tempDllPath = Config.getString(Config.KEY_BIZNEXUS_DLL_TEMP_PATH); 
	
	private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);

	//-----------------------------------------------------------------------------------------------------------------------------
	//SYSTEM LOAD 대신 사용 함수
	static {
		try {
			LOGGER.debug("------------------------------------------------------------------------------");
			LOGGER.debug("create temp dll file");
			// Get input stream from jar resource

			InputStream inputStream = new ClassPathResource("dll/TagAPI64.dll").getInputStream();
			String tempDir = HomeController.class.getClassLoader().getResource(".").toString();
			tempDir = tempDir.replace("file:/", "");
			LOGGER.debug(tempDir);
			File dir = new File(tempDir+"/tempDll");
			if(!dir.exists()) {
				dir.mkdir();
			}

			// Copy resource to filesystem in a temp folder with a unique name
			File temporaryDll = File.createTempFile("TagAPI64", ".dll", dir);
			FileOutputStream outputStream = new FileOutputStream(temporaryDll);
			byte[] array = new byte[8192];
			int read = 0;
			while ((read = inputStream.read(array)) > 0) {
				outputStream.write(array, 0, read);
			}
			outputStream.close();
			System.load(temporaryDll.getPath());
			// Delete on exit the dll
			temporaryDll.deleteOnExit();
			// Finally, load the dll
			LOGGER.debug("create end temp dll file");
			LOGGER.debug("------------------------------------------------------------------------------");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------	

	@ResponseBody
	@RequestMapping(value = "/req-tag", produces = "application/json; charset=UTF-8")
	public String ReqTag(Model model, @RequestBody String param ) {
		String strRet = "";

		TagAccess tagAccess = new TagAccess();
		int nRet = tagAccess.connect(reqTagIpAddr, "", reqTagIpPort);
		if(nRet == 0) 
		{
			strRet = tagAccess.exec(param); 
			// tagAccess.close();
		} else {
			strRet = "{}";
		}

		return strRet;
	}
	*/
}