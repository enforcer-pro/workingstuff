import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    static Configuration cfg =null;
    static SessionFactory sessionFactory =null;
    static {
        cfg= new Configuration();
        cfg.configure();
        sessionFactory=cfg.buildSessionFactory();

    }
    public static SessionFactory getSessionFactory(){
        return sessionFactory;
    }
}
