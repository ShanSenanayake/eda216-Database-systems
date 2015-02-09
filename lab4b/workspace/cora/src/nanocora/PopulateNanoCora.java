package nanocora;

import java.io.File;
import java.io.IOException;
import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;
import org.neo4j.graphdb.index.Index;
import org.neo4j.kernel.impl.util.FileUtils;

import common.RelTypes;

public class PopulateNanoCora {
	public static void main(String[] args) {
		String DB_PATH = "nanocora.db";

		System.out.print("Deleting old database ... ");
		try {
			FileUtils.deleteRecursively(new File(DB_PATH));
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		System.out.println("done.");

		System.out.print("Creating new database ... ");
		GraphDatabaseService db = new GraphDatabaseFactory()
				.newEmbeddedDatabase(DB_PATH);
		registerShutdownHook(db);
		System.out.println("done.");

		try (Transaction tx = db.beginTx()) {
			System.out.print("Creating indexes ... ");
			Index<Node> classificationIndex = db.index().forNodes(
					"classificationIndex");
			Index<Node> paperIndex = db.index().forNodes("paperIndex");
			Index<Node> authorIndex = db.index().forNodes("authorIndex");
			System.out.println("done.");

			System.out.print("Populating db ... ");
			Node[] classifications = new Node[2];
			classifications[0] = db.createNode();
			classifications[0].setProperty("name", "Databases");
			classificationIndex.add(classifications[0], "name", "Databases");
			classifications[1] = db.createNode();
			classifications[1].setProperty("name", "Relational");
			classificationIndex.add(classifications[1], "name", "Relational");
			classifications[1].createRelationshipTo(classifications[0],
					RelTypes.SUPER_CLASSIFICATION);

			Node[] papers = new Node[5];
			for (int i = 0; i < papers.length; i++) {
				Node p = db.createNode();
				p.setProperty("title", "p" + i);
				p.setProperty("year", 2001 + 2 * i);
				p.setProperty("url", "http://p" + i);
				paperIndex.add(p, "title", "p" + i);
				papers[i] = p;
			}

			Node[] authors = new Node[6];
			for (int i = 0; i < authors.length; i++) {
				Node a = db.createNode();
				a.setProperty("lastName", "a" + i);
				a.setProperty("initial", (char) ('d' + 2 * i));
				authorIndex.add(a, "lastName", "a" + i);
				authors[i] = a;
			}

			papers[0].createRelationshipTo(classifications[0],
					RelTypes.CLASSIFIED_AS);
			papers[1].createRelationshipTo(classifications[1],
					RelTypes.CLASSIFIED_AS);
			papers[2].createRelationshipTo(classifications[0],
					RelTypes.CLASSIFIED_AS);
			papers[3].createRelationshipTo(classifications[1],
					RelTypes.CLASSIFIED_AS);
			// paper 4 is unclassified

			papers[0].createRelationshipTo(authors[0], RelTypes.AUTHORED_BY);
			papers[0].createRelationshipTo(authors[1], RelTypes.AUTHORED_BY);
			papers[1].createRelationshipTo(authors[1], RelTypes.AUTHORED_BY);
			papers[1].createRelationshipTo(authors[2], RelTypes.AUTHORED_BY);
			papers[1].createRelationshipTo(authors[4], RelTypes.AUTHORED_BY);
			papers[2].createRelationshipTo(authors[3], RelTypes.AUTHORED_BY);
			// paper 3 has no author
			papers[4].createRelationshipTo(authors[5], RelTypes.AUTHORED_BY);

			papers[0].createRelationshipTo(papers[1], RelTypes.CITES);
			papers[0].createRelationshipTo(papers[2], RelTypes.CITES);
			papers[1].createRelationshipTo(papers[4], RelTypes.CITES);
			tx.success();
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("done.");

		System.out.print("Shutting down ... ");
		db.shutdown();
		System.out.println("done.");
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
