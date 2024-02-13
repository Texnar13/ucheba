public class Main {

    public static void main(String[] args) {
        Collection collection = new Collection(130).addLast(50).addLast(50)
                .addLast(120).addLast(185).addLast(27)
                .addLast(43).addLast(913).addLast(210)
                .addLast(5).addLast(17).addLast(245);
        //System.out.println(Element.findPosition(5, e));
        System.out.println(collection);

        collection.mergeSort();
        //collection.simpleBubbleSort();

        System.out.println(collection);
        collection.removeElement(1);
        System.out.println(collection);
        collection.removeElement(collection.findPosition(43));
        System.out.println(collection);

    }


}




