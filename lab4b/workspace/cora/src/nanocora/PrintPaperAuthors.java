package nanocora;

import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Relationship;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;
import org.neo4j.graphdb.factory.GraphDatabaseSettings;
import org.neo4j.graphdb.index.Index;
import common.RelTypes;

public class PrintPaperAuthors {
	public static void main(String[] args) {
		// The paper titles to search for.
		String searchString = "p*";

		// Open the database read only
		String DB_PATH = "nanocora.db";
		GraphDatabaseService db = new GraphDatabaseFactory()
				.newEmbeddedDatabaseBuilder(DB_PATH)
				.setConfig(GraphDatabaseSettings.read_only, "true")
				.newGraphDatabase();
		registerShutdownHook(db);

		try (Transaction tx = db.beginTx()) {
			Index<Node> paperIndex = db.index().forNodes("paperIndex");
			for (Node p : paperIndex.query("title", searchString)) {
				System.out.println(p.getProperty("title") + ", "
						+ p.getProperty("year"));
				System.out.print("    Authors: ");
				for (Relationship r : p.getRelationships(RelTypes.AUTHORED_BY)) {
					Node author = r.getEndNode();
					System.out.print(author.getProperty("lastName") + ", "
							+ author.getProperty("initial") + " / ");
				}
				System.out.println();
				System.out.println();
			}
			tx.success();
		} catch (Exception e) {
			e.printStackTrace();
		}
		db.shutdown();
	}

	private static void registerShutdownHook(final GraphDatabaseService db) {
		Runtime.getRuntime().addShutdownHook(new Thread() {
			@Override
			public void run() {
				db.shutdown();
			}
		});
	}
}
