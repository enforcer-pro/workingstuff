import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class HibernateTx {
    public void Hibernatetx(){
        SessionFactory sessionFactory=null;
        Session session=null;
        Transaction trans=null;
        try{
            sessionFactory=HibernateUtil.getSessionFactory();
            session=HibernateUtil.getSessionObject();
            trans=session.beginTransaction();
            
            trans.commit();

        }catch (Exception e){
            e.fillInStackTrace();
            trans.rollback();
        }finally {
            session.close();
            sessionFactory.close();
        }
    }
}
