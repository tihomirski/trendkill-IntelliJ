package come.example;

import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class TestRegisterCustomer {
//
//    private Countries countries = null;
//    private States states = null;
//    private Gson gson = new Gson();
//
//    /**
//     * <code>@Spy</code> if you want to call the actual code and
//     * create a test customer in CRMV2in order to test it later.
//     * If you want to capture and test the Customer object
//     * which is supposed to be sent to CRMV2, <code>@Mock</code> is enough.
//     */
//    @Spy
//    private CMSUtil cmsUtil;
//
//    @Spy
//    @InjectMocks
//    private CustomerServletsUtil customerServletsUtil;
//
//    @Captor
//    ArgumentCaptor<Customer> customerCaptor;
//
//    @Captor
//    ArgumentCaptor<String> siteCaptor;
//
//    @Mock private HttpSession mockHttpSession;
//    @Mock private ServletConfig servletConfig;
//    @Mock private HttpServletRequest request;
//    @Mock private HttpServletResponse response;
//    Map<String,Object> attributes = new HashMap<>();
//
//    @BeforeClass
//    public void init() {
//        System.out.println("init() - Class");
//
//        try {
//            ClassLoader classLoader = Sites.class.getClassLoader();
//
//            URL url = classLoader.getResource("resources/json_tables/states.json");
//            StringBuilder json = DBDumper.readJSON(url.getPath());
//            states = gson.fromJson(json.toString(), States.class);
//
//            url = classLoader.getResource("resources/json_tables/countries.json");
//            json = DBDumper.readJSON(url.getPath());
//            countries = gson.fromJson(json.toString(), Countries.class);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        MockitoAnnotations.openMocks(this);
//
//        request = mock(HttpServletRequest.class);
//        response = mock(HttpServletResponse.class);
//
//        HttpSession mockHttpSession = mock(HttpSession.class);
//        when(request.getSession()).thenReturn(mockHttpSession);
//
//        ServletContext mockServletContext = mock(ServletContext.class);
//        when(request.getServletContext()).thenReturn(mockServletContext);
//        when(request.getServletContext().getAttribute("states")).thenReturn(states);
//
//        when(request.getSession().getAttribute(anyString())).then(answer(
//                new Answer1<Object, String>() {
//                    public Object answer(String arg) {
//                        return attributes.get(arg);
//                    }
//                }));
//
//        verify(mockHttpSession, atLeast(0)).setAttribute(anyString(), any());
//        verify(mockHttpSession, atLeast(0)).getAttribute(anyString());
//
//    }
//
//    @Test
//    public void test() {
//
//        System.out.println("Test 1 - Main");
//
//        String randomEmail = Util.generateRandomAlphabetic(15) + "@lesvitalities.com";
//        Landing landing = Landing.DG_IOS;
//        when(request.getParameter("fname")).thenReturn("Testo");
//        when(request.getParameter("lname")).thenReturn("Testev");
//        when(request.getParameter("address")).thenReturn("Addr 12/A");
//        when(request.getParameter("city")).thenReturn("Sofia");
//        when(request.getParameter("phone")).thenReturn("1123581321");
//        when(request.getParameter("email")).thenReturn(randomEmail);
//        when(request.getParameter("postal")).thenReturn("12345");
//        when(request.getParameter("country")).thenReturn("CA");
//        when(request.getParameter("state")).thenReturn("ON");
////		when(request.getParameter("lang")).thenReturn("EN");
//        when(request.getParameter("siteid")).thenReturn("306");
//        when(request.getServletContext().getContextPath()).thenReturn(landing.getContextPath());
//        when(request.getLocale()).thenReturn(Locale.ENGLISH);
//        when(request.getParameter("productid")).thenReturn("3");
//
//        // Create Visit in CRMV2 and use that. There should be real visit and 1-to-1 visitid-customerid
//        Visit visit = new Visit();
////		visit.setVisitId(12345678);
//        visit.setVisitor("11111111");
//        visit.setAtrack("");
//        visit.setBtrack("");
//        visit.setCtrack("");
//        visit.setDtrack("");
//        visit.setEtrack("");
//        visit.setSiteName(landing.getOffer().getMasterSiteName());
//        visit.setCountry("BG");
//        VisitResponse visitResponse = cmsUtil.addVisitToCRMv2(visit);
//        assertNotNull(visitResponse);
//        assertNotNull(visitResponse.getVisit());
//
//        SessionVariables sessionVariables = new SessionVariables();
//        sessionVariables.setLanding(landing);
//        sessionVariables.setIp("127.0.0.1");
//        sessionVariables.setOfferid(32);
//        sessionVariables.setCurrency("CAD");
//        sessionVariables.setProba(true);
//        sessionVariables.setStateAbbr("ON");
//        sessionVariables.setOfferName(landing.getOffer().getName());
//        sessionVariables.setFingerprint("TEST_Dummy_FiNgErPrInTtTtTt");
//        sessionVariables.setVisit(visit);
//
//        when(request.getSession().getAttribute("session_vars")).thenReturn(sessionVariables);
//
//        try {
//            customerServletsUtil.registerCustomer(request, response);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//
//        verify(cmsUtil).addCustomerToCRMV2(customerCaptor.capture(), siteCaptor.capture());
//        Customer customerValue = customerCaptor.getValue();
//        String site = siteCaptor.getValue();
//        assertEquals(customerValue.getFirstName(), "Testo");
//
//        assertEquals("Testo", request.getParameter("fname"));
//
//        CustomersResponse customerResponse = cmsUtil.getCustomerByEmail(randomEmail, visit);
//        assertEquals(customerResponse.getCustomers().size(), 1);
//        Customer actualCustomer = customerResponse.getCustomers().get(0);
//
//        assertEquals(actualCustomer.getFirstName(), "Testo");
//        assertEquals(actualCustomer.getLastName(), "Testev");
//        assertEquals(actualCustomer.getBillingAddress(), "Addr 12/A");
//        assertEquals(actualCustomer.getBillingCity(), "Sofia");
//        assertEquals(actualCustomer.getBillingZip(), "12345");
//        assertEquals(actualCustomer.getBillingCountry(), "CA");
//        assertEquals(actualCustomer.getBillingState(), "ON");
//        assertEquals(actualCustomer.getPhone(), 1123581321);
//        assertEquals(actualCustomer.getEmail(), randomEmail);
//        assertNotNull(actualCustomer.getPassword());
//        assertEquals(actualCustomer.getPassword().length(), 8);
//        assertEquals(actualCustomer.getIp(), "127.0.0.1");
//        assertEquals(actualCustomer.getFingerprint(), "TEST_Dummy_FiNgErPrInTtTtTt");
//        assertEquals(actualCustomer.getLanguage(), "en");
//
//        assertEquals(actualCustomer.getCurrency(), "CAD");
//
//        assertEquals(actualCustomer.getMailPromoLevel(), new Integer(1));
//        assertTrue(actualCustomer.getAllowemailing());
//
//        assertEquals(actualCustomer.getOrders().size(), 0);
//        assertEquals(actualCustomer.getPayments().size(), 0);
//
//        assertNull(actualCustomer.getOrders());
//        assertNull(actualCustomer.getPayments());
//
//    }
//
//    @Test
//    public void test2() {
//        System.out.println("Test 2");
//    }
//
//    @AfterClass
//    public void finalise() {
//        System.out.println("finalise()");
//    }

}
