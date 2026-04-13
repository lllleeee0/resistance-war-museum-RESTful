package restful.bean;

public class Result {
    private int code;
    private String description;
    private Object data;
    private String nextAction;

    public Result(int code, String description, Object data, String nextAction) {
        this.code = code;
        this.description = description;
        this.data = data;
        this.nextAction = nextAction;
    }

    public static Result failure(String msg) {
        return new Result(500, msg, null, null);
    }

    public static Result success(String msg, Object data) {
        return new Result(200, msg, data, null);
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNextAction() {
        return nextAction;
    }

    public void setNextAction(String nextAction) {
        this.nextAction = nextAction;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }


}