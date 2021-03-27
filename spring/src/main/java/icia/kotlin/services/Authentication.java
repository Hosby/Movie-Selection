package icia.kotlin.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.servlet.ModelAndView;

import icia.kotlin.beans.Member;
import icia.kotlin.mapper.MapperInterface;

@Service
public class Authentication {

	@Autowired
	private MapperInterface mapper;
	@Autowired
	private PlatformTransactionManager tran;
	
	public Authentication() {}
	
	public ModelAndView entrance(Member m) {
				
		ModelAndView mav = null;
		
		switch(m.getSCode()){
		case "A":
			mav = this.loginCtl(m);
			break;
		}
		
		return mav;
	}
	
	private ModelAndView loginCtl(Member m) {
		ModelAndView mav = null;
		
		TransactionStatus status = tran.getTransaction(new DefaultTransactionDefinition());
		
		mav = new ModelAndView();
		try {
			if(this.isMember(m)) {
				if(this.isAccess(m)) {
					mav.addObject("member", this.getMemberInfo(m));
				}
			}	
		}catch(Exception e) {
			e.printStackTrace();
			tran.rollback(status);
		}	
		mav.setViewName("loginForm");
		
		return mav;
	}
	
	private boolean convertToBoolean(int value) {
		return value==1? true: false;
	}
	
	/* Member 여부 확인 */
	private boolean isMember(Member member) {
		return convertToBoolean(mapper.isMember(member));
	}
	
	/* 액세스 가능 여부 : 패스워드 일치 여부 */
	private boolean isAccess(Member member) {
		return convertToBoolean(mapper.isAccess(member));
	}
	
	/* 회원정보 가져오기 */
	private Member getMemberInfo(Member member) {
		return mapper.getMemberInfo(member);
	}
	
}
