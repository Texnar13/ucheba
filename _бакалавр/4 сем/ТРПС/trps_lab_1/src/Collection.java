class Collection {

    private Element first;
    private Element last;// todo заменить на getLast?

    // ------------ конструкторы ------------

    public Collection() {
        first = null;
        last = null;
    }

    public Collection(int firstNumber) {
        first = new Element(firstNumber);
        last = first;
    }


    // ------------ сортировки ------------

    public void simpleBubbleSort() {
        Element currentCycle = first;
        while (currentCycle != null) {
            Element current = first;
            while (current != null) {
                if (current.next != null) {
                    if (current.number > current.next.number) {
                        int b = current.number;
                        current.number = current.next.number;
                        current.next.number = b;
                    }
                }
                current = current.next;
            }
            currentCycle = currentCycle.next;
        }
    }

    /**
     * Сортирует содержащийся в экземпляре список, используя рекурсивную сортировку слиянием
     **/
    public void mergeSort() {
        first = mergeSort(first);

        // находим последний элемент
        last = first;
        if(last != null){
            while (last.next != null) last = last.next;
        }
    }

    private static Element mergeSort(Element head) {

        // первым делом прогверяем крайние значения
        if (head == null) return null;
        if (head.next == null) return head;


        // разделяем лист на 2
        Element firstListLast = getMiddle(head);
        Element secondListHead = firstListLast.next;

        firstListLast.next = null;

        // сортируем два листа и возвращаем их сумму
        return merge(mergeSort(head), mergeSort(secondListHead));
    }

    private static Element merge(Element firstList, Element secondList) {
        Element head = new Element(-1);
        Element current = head;
        // надо слить два списка, смотрим в каком элемент меньше, из того и берем
        while (firstList != null && secondList != null) {
            if (firstList.number > secondList.number) {
                current.next = secondList;
                secondList = secondList.next;
            } else {
                current.next = firstList;
                firstList = firstList.next;
            }
            current = current.next;
        }
        // внутри каждого из двух списков элементы отсортированы,
        // по этому переписываем оставшуюся часть без изменений
        if (firstList == null) {
            for (Element iterator = secondList; iterator != null; iterator = iterator.next) {
                current.next = iterator;
                current = current.next;
            }
        } else
            for (Element iterator = firstList; iterator != null; iterator = iterator.next) {
                current.next = iterator;
                current = current.next;
            }
        return head.next;
    }

    private static Element getMiddle(Element head) {
        if (head == null) return null;

        // кол-во элементов
        int count = 0;
        Element result = head;
        while (result != null) {
            count++;
            result = result.next;
        }

        // половина это сколько?
        count = (count - 1) / 2;

        // находим и возвращаем средний
        result = head;
        while (count > 0) {
            count--;
            result = result.next;
        }
        return result;
    }


    // ------------ поиск элемента ------------

    int findPosition(int searchNumber) {
        Element tempFirst = first;// 2
        int answer = -1;// 2
        int currentPosition = 0;// 2
        while (tempFirst != null && answer == -1) {// 1 + (2 + 2)
            if (tempFirst.number == searchNumber) {// 1 + (2)
                answer = currentPosition;// 2
            } else {
                tempFirst = tempFirst.next;// 2
                currentPosition++;// 1
            }
        }
        return answer;
    }


    // ------------ удаление ------------

    void removeElement(int position) {
        if (first != null) {// 1 + (1)
            if (position == 0) {// 1 + (1)
                first = first.next;// 2
                if (first == null) {// 1 + (1)
                    last = null;// 1
                }
            } else if (position > 0) {// 1 + (1)
                Element tempFirst = first;// 2
                while (position > 1 && tempFirst != null) {// 1 + (1+1)
                    tempFirst = tempFirst.next;// 2
                    position--;// 1
                }
                if (tempFirst != null) {// 1 + (1)
                    if (tempFirst.next != null) {// 1 + (1)
                        if (tempFirst.next.next == null) {// 1 + (1)
                            last = tempFirst;// 2
                            tempFirst.next = null;// 1
                        } else
                            tempFirst.next = tempFirst.next.next;// 2
                    }
                }
            }
        }
    }


    // ------------ добавление ------------

    Collection addLast(int newE) {
        if (first == null) {
            first = new Element(newE);
            last = first;
        } else {
            last.next = new Element(newE);
            last = last.next;
        }
        return this;
    }

    @Override
    public String toString() {
        return "Collection:[" + first + ']';
    }


    private static class Element {

        int number;
        Element next;


        public Element(int number) {
            this.number = number;
        }


        @Override
        public String toString() {
            return '\"' + Integer.toString(number) + ((next == null) ? ('\"') : ("\", " + next.toString()));
        }
    }
}
