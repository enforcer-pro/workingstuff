import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    static Configuration cfg =null;
    static SessionFactory sessionFactory =null;
    static  Session session =null;
    static {
        cfg= new Configuration();
        cfg.configure();
        sessionFactory=cfg.buildSessionFactory();
        session = sessionFactory.openSession();

    }
    public static SessionFactory getSessionFactory(){
        return sessionFactory;
    }
    public static Session getSessionObject(){
        return session;
    }
}
